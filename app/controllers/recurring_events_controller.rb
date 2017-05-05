class RecurringEventsController < ApplicationController
  def index
    @recurring_events = RecurringEvent.all
  end

  def create
    @recurring_event = RecurringEvent.new(event_params)

    if @recurring_event.save
      redirect_to :root
    else
      flash.now[:errors].full_messages
    end
  end

  def new
  end

  def update
  end

  def destroy
  end

  private
  def event_params
    params.require(:recurring_event).permit(:name, :start_date, :interval, :buffer, :day_of_month)
  end
end
