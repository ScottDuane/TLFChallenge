class RecurringEvent < ActiveRecord::Base
  validates :name, :start_date, :interval, :day_of_month, presence: true
  # validates that buffer and interval are positive integers
  # validates that the date is today or in the future
  def get_next_occurrences(n)
    today = Date.today
    last_occurrence = get_past_occurrences.last
    occurrences = []
    year = last_occurrence.year
    month = last_occurrence.month
    day = self.day_of_month

    (1..n).each do |i|
      month += self.interval
      year = month > 12 ? year + 1 : year
      month = (month % 12) + 1
      occurrences << Date.new(year, month, day)
    end

    occurrences
  end

  private
  def get_past_occurrences
    start_month = self.start_date.day < self.day_of_month ? self.start_date.month : self.start_date.month + 1

    occurrences = []
    today = Date.today
    year = self.start_date.year
    month = start_month
    day = self.day_of_month
    occurrence = Date.new(year, month, day)

    until occurrence > today
      occurrences << occurrence
      month += self.interval
      year = month > 12 ? year + 1 : year
      month = (month % 12) + 1
      occurrence = Date.new(year, month, day)
    end

    occurrences
  end
end
