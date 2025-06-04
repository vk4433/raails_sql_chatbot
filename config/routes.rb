Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users, controllers: {
    confirmations: 'users/confirmations'
  }
  get "home/index"
  resources :sql_credentials, only: [ :new, :create, :show, :edit, :update ]
  resources :chathistory, only: [ :index, :create ]
  
  # Admin routes for user confirmation
  get 'admin/confirm_users', to: 'admin#confirm_users'
  post 'admin/confirm_user/:id', to: 'admin#confirm_user', as: 'admin_confirm_user'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
