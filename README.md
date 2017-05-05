# TrueLink Recurring Events

This is a small CRUD app that allows users to view, create, update, and destroy recurring events. Notable features:

- Ensures that delivery dates are not holidays or Saturdays
- The root url redirects to an index of recurring events
- Each event links to a show page and an edit/destroy page  
- Unit tests on the RecurringEvent model test that database and model level validations hold, as well as some of the basic scheduling functionality

Instructions for use:

- Spin up a Rails server with `rails s` and navigate to the root page
- If you want to (re)seed the database, `rake db:seed` will seed 6 sample events

Simplifying assumptions:

- Users are currently allowed to pick start dates that are in the past or future
- Leap years don't happen -- all Februaries have 28 days

With more time I would:

- Style this app -- it's pretty darn ugly right now
- Refactor the views using partials, in particular a `_form.html.erb`
- Render errors directly onto the page
- Add in buffer days bonus
- Write additional tests, in particular integration tests using Capybara
