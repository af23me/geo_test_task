# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  if Rails.env.development?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :geolocations, only: %i[create] do
        collection do
          get '/search', to: 'geolocations#show'
          delete '/destroy', to: 'geolocations#destroy'
        end
      end
    end
  end
end
