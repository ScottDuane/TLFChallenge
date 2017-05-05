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
end
