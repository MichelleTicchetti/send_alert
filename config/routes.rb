# == Route Map
#

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users do
    member do
      patch :mark_all_alerts_as_read
      get :subscriptions
    end
    collection do
      get :unread_and_unexpired_alerts
    end
  end

  resources :alerts, only: [ :create ] do
    collection do
      get :unexpired_for_topic
      get :user_unread_and_unexpired
    end
    member do
      patch :mark_as_read
    end
  end

  resources :subscriptions, only: [ :create, :destroy ]
  resources :topics, only: [ :index, :create, :destroy ]
end
