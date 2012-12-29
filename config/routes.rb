Rails.application.routes.draw do

  namespace :api, :defaults=>{:format => 'json'} do
    namespace :v1 do
      resources :bike_mfg_queries, :only=>[] do
        collection do
          get 'search'
          get 'search_models'
          get 'search_brands'
        end
      end
    end
  end


end
