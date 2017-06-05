require 'test_helper'

class RecurringEventTest < ActiveSupport::TestCase
  test "should not save event without a name" do
    today = Date.today
    event_start = Date.new(today.year + 1, today.month, today.day)
    event = RecurringEvent.new(day_of_month: 5, start_date: event_start, interval: 3)
    assert_not event.save
  end

  test "should not save event without start date" do
    event = RecurringEvent.new(name: "a test event", interval: 3, day_of_month: 3)
    assert_not event.save
  end

  test "should not save event with negative recurrence interval" do
    today = Date.today
    event_start = Date.new(today.year + 1, today.month, today.day)
    event = RecurringEvent.new(name: "another test event", interval: -1, start_date: event_start)
    assert_not event.save
  end

  test "should not save event without a day of the month" do
    today = Date.today
    event_start = Date.new(today.year + 1, today.month, today.day)
    event = RecurringEvent.new(name: "another test event", interval: -1, start_date: event_start)
    assert_not event.save
  end

  test "should start delivery in the current month when possible" do
    event_start = Date.new(2018, 2, 1)

    event = RecurringEvent.new(name: "May the fourth be with you", start_date: event_start, interval: 2, day_of_month: 2)
    event.save!
    expected_date = Date.new(2018, 2, 2)
    actual_date = event.get_first_occurrence
    assert_equal(expected_date, actual_date)
  end

  test "should skip to next month if this month's delivery date has passed" do
    event_start = Date.new(2017, 5, 24)

    event = RecurringEvent.new(name: "May the fourth NOT be with you", start_date: event_start, interval: 3, day_of_month: 2)
    event.save!
    expected_date = Date.new(2017, 6, 2)
    actual_date = event.get_first_occurrence
    assert_equal(expected_date, actual_date)
  end

  test "should not deliver on a weekend" do
    event_start = Date.new(2017, 5, 10)
    event = RecurringEvent.new(name: "I love Saturdays", start_date: event_start, interval: 1, day_of_month: 20)
    event.save!
    delivery_dates = event.get_next_occurrences(20)
    delivery_dates.each do |date|
      assert_not date.saturday? || date.sunday?
    end
  end

  test "should not deliver on a holiday" do
    event_start = Date.new(2017, 6, 10)
    event = RecurringEvent.new(name: "Glorious patriotism", start_date: event_start, interval: 1, day_of_month: 4)
    event.save!
    delivery_date = event.get_next_occurrences(1).first
    assert_not delivery_date.day == 4
  end

  test "event start date on Nov 2 with day of month 3 behaves correctly" do
    event_start = Date.new(2017, 11, 2)
    event = RecurringEvent.new(name: "Test November", start_date: event_start, interval: 1, day_of_month: 3)
    event.save!
    expected_start = Date.new(2017, 11, 3)
    actual_start = event.get_first_occurrence
    assert_equal(expected_start, actual_start)

    next_occurrences = event.get_next_occurrences(3)
    december_occurrence = Date.new(2017, 12, 1)
    january_occurrence = Date.new(2018, 1, 3)
    assert_equal(expected_start, next_occurrences[0])
    assert_equal(december_occurrence, next_occurrences[1])
    assert_equal(january_occurrence, next_occurrences[2])
  end
end
