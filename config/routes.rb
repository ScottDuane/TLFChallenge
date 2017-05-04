Rails.application.routes.draw do
  resources :recurring_events
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect("/recurring_events")
end
