Rails.application.routes.draw do
  resources :bike_models, :only => [:index]
end
