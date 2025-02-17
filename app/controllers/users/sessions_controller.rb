class Users::SessionsController < Devise::SessionsController
  include DeviseHelper
  before_action :configure_sign_in_params, only: [ :create ]

  # Adiciona os helpers do Devise
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Sobrescrevendo o método create para incluir a validação do perfil
  def create
    self.resource = warden.authenticate!(auth_options)

    if resource && resource.persisted?
      # Verifica se o perfil_id foi fornecido e pertence ao usuário
      if params[:user][:perfil_id].present?
        perfil = Perfil.find_by(id: params[:user][:perfil_id])

        if perfil && perfil.kept?
          sign_in(resource_name, resource)
          session[:perfil_id] = perfil.id
          respond_with resource, location: after_sign_in_path_for(resource)
        else
          sign_out(resource)
          flash[:alert] = "Perfil inválido ou inativo"
          redirect_to new_user_session_path
        end
      else
        sign_out(resource)
        flash[:alert] = "Por favor, selecione um perfil"
        redirect_to new_user_session_path
      end
    else
      respond_with resource
    end
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password, :perfil_id ])
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end
end
