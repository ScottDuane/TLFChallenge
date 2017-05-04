class CreateRecurringEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :recurring_events do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.integer :interval, default: 1
      t.integer :day_of_month, null: false
      t.integer :buffer, default: 1
      t.timestamps 
    end
  end
end
