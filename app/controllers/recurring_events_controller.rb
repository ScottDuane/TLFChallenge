class RecurringEventsController < ApplicationController
  def index
    @recurring_events = RecurringEvent.all
  end

  def create
    @recurring_event = RecurringEvent.new(event_params)

    if @recurring_event.save
      redirect_to :root
    else
      flash.now[:errors] = @recurring_event.errors.full_messages
      render :new
    end
  end

  def new
  end

  def show
    @recurring_event = RecurringEvent.find(params[:id])
  end

  def edit
    @recurring_event = RecurringEvent.find(params[:id])
  end

  def update
    @recurring_event = RecurringEvent.find(params[:id])

    if @recurring_event.update(event_params)
      redirect_to @recurring_event
    else
      flash.now[:errors] = @recurring_event.errors.full_messages
      render :edit
    end
  end

  def destroy
    @recurring_event = RecurringEvent.find(params[:id])
    @recurring_event.destroy!
    redirect_to :root
  end

  private
  def event_params
    params.require(:recurring_event).permit(:name, :start_date, :interval, :buffer, :day_of_month)
  end
end
