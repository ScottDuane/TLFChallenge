class RecurringEventsController < ApplicationController
  def index
    @recurring_events = RecurringEvent.all
  end

  def new
  end

  def update
  end

  def destroy
  end
  
end
