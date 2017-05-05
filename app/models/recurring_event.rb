class RecurringEvent < ActiveRecord::Base
  validates :name, :start_date, :interval, :day_of_month, presence: true
  validate :day_of_month_is_valid
  validate :interval_is_valid


  def get_next_occurrences(n)
    today = Date.today
    day = self.day_of_month
    occurrences = []

    if compare_dates(today, self.start_date)
      first_occurrence = get_first_occurrence
      month = first_occurrence.month
      year = first_occurrence.year
    else
      last_occurrence = get_past_occurrences.last
      month = last_occurrence.month + self.interval
      year = last_occurrence.year

      if month > 12
        month -= 12
        year += 1
      end
    end

    (1..n).each do |i|
      day = get_last_day_of_month(day, month) if day > 28
      occurrence = Date.new(year, month, day)
      occurrence = get_actual_occurrence(occurrence) if is_holiday_or_weekend?(occurrence)
      occurrences << occurrence
      month += self.interval

      if month > 12
        month -= 12
        year += 1
      end
    end

    occurrences
  end

  def get_day_suffix
    case self.day_of_month % 10
      when 1
        return "st"
      when 2
        return "nd"
      when 3
        return "rd"
      else
        return "th"
    end
  end

  private
  def get_past_occurrences
    start_month = self.start_date.day < self.day_of_month ? self.start_date.month : self.start_date.month + 1

    occurrences = []
    today = Date.today
    year = self.start_date.year
    month = start_month
    day = self.day_of_month

    occurrence = nil
    until compare_dates(today, occurrence)
      occurrence = Date.new(year, month, day)
      occurrences << occurrence

      month += self.interval
      if month > 12
        month -= 12
        year += 1
      end
    end

    occurrences.pop
    occurrences
  end

  def get_first_occurrence
    year = self.start_date.year
    month = self.start_date.month
    day = self.day_of_month

    today = Date.today
    if today.day > day
      month += 1
    end

    if month > 12
      month -= 12
      year += 1
    end

    Date.new(year, month, day)
  end

  def compare_dates(date1, date2)
    return false unless date1 && date2

    return true if date1.year < date2.year
    return false if date2.year < date1.year

    return true if date1.month < date2.month
    return false if date2.month < date1.month

    return true if date1.day < date2.day
    return false if date2.day < date1.day

    true
  end

  def is_holiday_or_weekend?(date)
    return true if date.saturday? || date.sunday?

    case date.month
      when 1
        return true if date.day == 1
        return true if date.monday? && date.day/7 == 2
      when 2
        return true if date.monday? && date.day/7 == 2
      when 5
        return true if date.monday? && date.day/7 == 4
      when 7
        return true if date.day == 4
      when 9
        return true if date.monday? && date.day/7 == 0
      when 10
        return true if date.monday? && date.day/7 == 0
      when 11
        return true if date.thursday? && date.day/7 == 3
      when 12
        return true if date.day == 25
      else
        return false
    end
  end

  def get_last_day_of_month(day, month)
    last_days = { 1 => 31,
                  2 => 28,
                  3 => 31,
                  4 => 30,
                  5 => 31,
                  6 => 30,
                  7 => 31,
                  8 => 31,
                  9 => 31,
                  10 => 31,
                  11 => 31,
                  12 => 31 }
    if last_days[month] < day
      return last_days[month]
    end 
  end

  def get_actual_occurrence(date)
    year = date.year
    month = date.month
    day = date.day

    while is_holiday_or_weekend?(date)
      day = day - 1
      month = day < 1 ? month - 1 : month
      year = month < 1 ? year - 1 : year
      date = Date.new(year, month, day)
    end

    date
  end

  def future_start_date
    errors.add(:start_date, "Start date cannot be in the past") unless compare_dates(Date.today, self.start_date)
  end

  def interval_is_valid
    errors.add(:interval, "There must be at least 1 month between occurrences.") unless self.interval && self.interval > 0
  end

  def day_of_month_is_valid
    errors.add(:day_of_month, "Invalid day of month.") unless self.day_of_month && (self.day_of_month > 0 && self.day_of_month < 32)
  end
end
