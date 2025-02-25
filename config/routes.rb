Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :perfil_users
  namespace :concerns do
    get "authorization/check_permissions"
    get "authorization/user_has_permission"
  end

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
    root to: "dashboard#index"
    
    resources :dashboard, only: [:index]
    resources :pages do
      collection do
        post :update_profile
        post :import_csv
        get :filter
        get :results
        get :settings
        get :proposta
      end
    end
    
    resources :profile, only: [] do
      collection do
        post :update
        post :update_contacts
        post :update_password
      end
    end
  end

  # Test resources
  resources :tests do
    member do
      patch :discard
      patch :undiscard
    end
  end
end
