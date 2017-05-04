class RecurringEvent < ActiveRecord::Base
  validates :name, presence: true
  # validates that buffer and interval are positive integers
  # validates that the date is today or in the future 
end
