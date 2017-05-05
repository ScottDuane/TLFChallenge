# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
date1 = Date.new(2014, 4, 4)
RecurringEvent.create({ name: 'Feed Ernest the dog', start_date: date1, interval: 3, day_of_month: 9 })
date2 = Date.new(2017, 1, 9)
RecurringEvent.create({ name: 'Do the laundry', start_date: date2, interval: 7, day_of_month: 13 })
date3 = Date.new(2011, 10, 31)
RecurringEvent.create({ name: 'Go to a haunted house', start_date: date3, interval: 12, day_of_month: 31 })
date4 = Date.new(2016, 11, 30)
RecurringEvent.create({ name: 'Pay the rent', start_date: date4, interval: 1, day_of_month: 30 })
date5 = Date.new(2018, 5, 15)
RecurringEvent.create({ name: 'Celebrate the solstice', start_date: date5, interval: 6, day_of_month: 15 })
date6 = Date.new(1867, 7, 1)
RecurringEvent.create({ name: 'Elect a German chancellor', start_date: date6, interval: 48, day_of_month: 1 })
