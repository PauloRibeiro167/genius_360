Rails.application.routes.draw do
  namespace :consulta do
    resources :servidor_federals
  end
  # Configuração do Devise com controller customizado e novas rotas de sign_out
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, sign_out_via: [:get, :delete]  # Adicionando GET para sign_out
  
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

  resources :contact_messages, only: [ :create ]

  get "pwa/manifest", to: "pwa#manifest", format: "json", as: "pwa_manifest"
  get "pwa/pwa"

  get 'users/check_cpf', to: 'users#check_cpf'

  namespace :public do
    get "/", to: "pages#index"
    get "sobre", to: "pages#sobre"
    get "servico", to: "pages#servico"
    get "precos", to: "pages#precos"
    get "contato", to: "pages#contato"
  end

  root "public/pages#index"

  namespace :admin do
    root to: "dashboard#index"

    resources :dashboard, only: [ :index ]
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

    resource :profile, only: [], controller: "profile" do
      collection do
        post :update
        post :update_contacts
        post :update_password
      end
    end

    resources :notifications, only: [ :index ] do
      collection do
        post :mark_all_as_read
      end
      member do
        post :mark_as_read
      end
    end

    get "notificacoes", to: "pages#notificacoes"
    resources :messages, only: [ :create, :index ]
    get "comunicados", to: "pages#comunicados"
    resources :avisos, only: [ :create, :destroy ]
    resources :reunioes, only: [ :create, :destroy, :index ]
    resources :reunioes, only: [ :index ]
    get "users/search", to: "users#search", as: :search_users

    post "profile/update", to: "profile#update"
    post "profile/update_password", to: "profile#update_password", as: :profile_update_password

    resources :api_manager, only: [] do
      collection do
        get :start
        get :status
      end
    end
    get "/admin/api_manager/start"

    resources :propostas do
      collection do
        get :consulta_servidor
        post :buscar_servidor
        get :selecionar_consulta
        get :search_users  # Adicione esta linha
        post :redirecionar_consulta
        get :consulta_servidores_federais
        get :consulta_servidores_pi
        get :consulta_servidores_ce
        get :consulta_beneficios
        post :buscar_servidores_federais
        post :buscar_servidores_pi
        post :buscar_servidores_ce
        post :buscar_beneficios
        get :filter_by_prazo
      end
      
      member do
        get :next_step
        get :previous_step
      end
    end

    resources :users, only: [:new, :create]
  end

  namespace :api do
    resources :pbc, only: [ :index, :show ]
    resources :serv_ce do
      collection do
        get :search
      end
    end
  end

  resources :tests do
    member do
      patch :discard
      patch :undiscard
    end
  end

  post '/csp-violation-report', to: 'csp#violation_report'
end
