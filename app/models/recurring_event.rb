class RecurringEvent < ActiveRecord::Base
  validates :name, :start_date, :interval, :day_of_month, presence: true
  validate :day_of_month_is_valid
  validate :interval_is_valid

  LAST_DAYS = { 1 => 31,
                2 => 28,
                3 => 31,
                4 => 30,
                5 => 31,
                6 => 30,
                7 => 31,
                8 => 31,
                9 => 30,
                10 => 31,
                11 => 30,
                12 => 31 }

  def get_next_occurrences(n)
    today = Date.today
    occurrences = []

    month_year_data = is_first_date_less_than_second(today, self.start_date) ? get_next_for_future_starts : get_next_for_past_starts
    month = month_year_data[0]
    year = month_year_data[1]

    end_of_month = self.day_of_month > 28
    day = end_of_month ? LAST_DAYS[month] : self.day_of_month

    (1..n).each do |i|
      occurrence = Date.new(year, month, day)
      occurrence = get_actual_occurrence(occurrence) if is_holiday_or_weekend?(occurrence)
      occurrences << occurrence
      month += self.interval

      until month <= 12
        month -= 12
        year += 1
      end

      day = end_of_month ? LAST_DAYS(day, month) : day
    end

    occurrences
  end

  def get_next_for_future_starts
    first_occurrence = get_first_occurrence
    month = first_occurrence.month
    year = first_occurrence.year
    [month, year]
  end

  def get_next_for_past_starts
    last_occurrence = get_past_occurrences.last
    month = last_occurrence.month + self.interval
    year = last_occurrence.year

    until month <= 12
      month -= 12
      year += 1
    end

    [month, year]
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

  def get_past_occurrences
    occurrences = []
    end_of_month = self.day_of_month > 28
    today = Date.today

    occurrence = get_first_occurrence
    year, month, day = occurrence.year, occurrence.month, occurrence.day
    until is_first_date_less_than_second(today, occurrence)
      occurrence = Date.new(year, month, day)
      occurrences << occurrence

      month += self.interval
      until month <= 12
        month -= 12
        year += 1
      end

      day = end_of_month ? LAST_DAYS[month] : day
    end

    occurrences.pop
    occurrences
  end

  def get_first_occurrence
    year = self.start_date.year
    month = self.start_date.month
    day = self.day_of_month

    if self.start_date.day > day
      month += 1
    end

    until month <= 12
      month -= 12
      year += 1
    end

    Date.new(year, month, day)
  end

  def is_first_date_less_than_second(date1, date2)
    return false unless date1 && date2
    date1 < date2
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

  # def get_last_day_of_month(day, month)
  #   last_days = { 1 => 31,
  #                 2 => 28,
  #                 3 => 31,
  #                 4 => 30,
  #                 5 => 31,
  #                 6 => 30,
  #                 7 => 31,
  #                 8 => 31,
  #                 9 => 30,
  #                 10 => 31,
  #                 11 => 30,
  #                 12 => 31 }
  #
  #   last_days[month]
  # end

  def get_actual_occurrence(date)
    year = date.year
    month = date.month
    day = date.day

    while is_holiday_or_weekend?(date)
      day = day - 1
      if day < 1
        month = month - 1
        day = LAST_DAYS[month]
      end

      if month < 1
        year = year - 1
      end

      date = Date.new(year, month, day)
    end

    date
  end

  def future_start_date
    errors.add(:start_date, "Start date cannot be in the past") unless is_first_date_less_than_second(Date.today, self.start_date)
  end

  def interval_is_valid
    errors.add(:interval, "There must be at least 1 month between occurrences.") unless self.interval && self.interval > 0
  end

  def day_of_month_is_valid
    errors.add(:day_of_month, "Invalid day of month.") unless self.day_of_month && (self.day_of_month > 0 && self.day_of_month < 32)
  end
end
