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
        get :index
        get :settings
        get :proposta
        get :mensagens
        get :comunicados
        get :filter
        get :results
        post :import_csv
        patch :update_profile
      end
    end
    
    resource :profile, only: [], controller: 'profile' do
      collection do
        post :update
        post :update_contacts
        post :update_password
      end
    end

    resources :notifications, only: [:index] do
      collection do
        post :mark_all_as_read
      end
      member do
        post :mark_as_read
      end
    end

    get 'notificacoes', to: 'pages#notificacoes'
    resources :messages, only: [:create, :index]
    get 'comunicados', to: 'pages#comunicados'
    resources :avisos, only: [:create, :destroy]
    resources :reunioes, only: [:create, :destroy, :index]
    resources :reunioes, only: [:index]
    get 'users/search', to: 'users#search', as: :search_users

    post 'profile/update', to: 'profile#update'
    post 'profile/update_password', to: 'profile#update_password', as: :profile_update_password

    # API Manager routes
    resources :api_manager, only: [] do
      collection do
        get :start
        get :status
      end
    end
    get '/admin/api_manager/start'

    resources :propostas do
      collection do
        get :consulta_servidor
        post :buscar_servidor
        get :selecionar_consulta
        post :redirecionar_consulta
        get :consulta_servidores_federais
        get :consulta_servidores_pi
        get :consulta_servidores_ce
        get :consulta_beneficios
        post :buscar_servidores_federais
        post :buscar_servidores_pi
        post :buscar_servidores_ce
        post :buscar_beneficios
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