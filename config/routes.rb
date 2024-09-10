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

  # User routes
  resources :users, only: [:index, :show, :create, :update, :destroy] do
    member do
      patch :mark_all_alerts_as_read       # PATCH /users/:id/mark_all_alerts_as_read
      get :subscriptions                   # GET /users/:id/subscriptions
      get :alerts                          # GET /users/:id/alerts (opcional con filtros params[:unread], params[:expired], params[:unexpired]) ej: {base_url}/users/1/alerts?unread=true&expired=true
      patch 'mark_alert_as_read/:alert_id', to: 'users#mark_alert_as_read', as: 'mark_alert_as_read'
    end
    collection do
      post :subscribe_to_topic        # POST /users/subscribe_to_topic
      delete :unsubscribe_from_topic  # DELETE /users/unsubscribe_from_topic
    end
  end

    # Alert routes
    resources :alerts, only: [:create, :index] do
      collection do
        get :unexpired_for_topic             # GET /alerts/unexpired_for_topic
      end
      member do
        patch :mark_as_read                  # PATCH /alerts/:id/mark_as_read
      end
    end

    # Subscription routes
    resources :subscriptions, only: [:index, :create, :destroy]

    # Topic routes
    resources :topics, only: [:index, :create, :destroy]
  end
