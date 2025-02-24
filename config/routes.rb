Rails.application.routes.draw do
  resources :perfil_users
  namespace :concerns do
    get "authorization/check_permissions"
    get "authorization/user_has_permission"
  end
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :perfil_permissions do
    member do
      patch :discard
    end
  end
  resources :permissions
  resources :permissions do
    member do
      patch :discard
      patch :undiscard
    end
  end

  resources :action_permissions do
    member do
      patch :discard
      patch :undiscard
    end
  end

  resources :controller_permissions do
    member do
      patch :discard
      patch :undiscard
    end
  end

  resources :perfils do
    member do
      patch :discard
      patch :undiscard
    end
  end

  resources :contact_messages, only: [:create]

  # PWA routes
  get "pwa/manifest", to: "pwa#manifest", format: "json", as: "pwa_manifest"
  get "pwa/pwa"

  # Public routes
  namespace :public do
    get "/", to: "pages#index"
    get "sobre", to: "pages#sobre"
    get "servico", to: "pages#servico"
    get "precos", to: "pages#precos"
    get "contato", to: "pages#contato"
  end

  # Root route
  root "public/pages#index"

  # Admin routes
  namespace :admin do
    get "dashboard/index"
    get "pages/index"
    get "pages/settings"
    root to: "dashboard#index"
    post 'profile/update', to: 'profile#update', as: :update_profile
    post 'profile/update_contacts', to: 'profile#update_contacts', as: :update_profile_contacts
    post 'profile/update_password', to: 'profile#update_password', as: :update_password
  end

  # Test resources
  resources :tests do
    member do
      patch :discard
      patch :undiscard
    end
  end
end
