class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :verify_signed_out_user, only: [:new, :create]
  before_action :log_request_info
  respond_to :html, :json, :turbo_stream

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

  def new
    @resource = User.new
    Rails.logger.info "==== Acessando action NEW do SessionsController ===="
    Rails.logger.info "Após o login, o usuário será redirecionado para: #{after_sign_in_path_for(resource)}"
    begin
      render "devise/sessions/new"
    rescue => e
      Rails.logger.error "Erro ao renderizar login: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:alert] = "Erro ao carregar página de login. Por favor, tente novamente."
      redirect_to root_path
    end
  end

  def create
    Rails.logger.info "==== Tentando autenticar usuário ===="
    Rails.logger.info "Email tentando login: #{params[:user][:email]}"
    
    begin
      # Verificar se o usuário existe
      user = User.find_by(email: params[:user][:email])
      if user
        Rails.logger.info "Usuário encontrado no banco"
        Rails.logger.info "Perfil do usuário: #{user.perfil.try(:name)}"
        
        # Adicionar log para verificar a senha
        Rails.logger.info "Verificando senha..."
      else
        Rails.logger.info "Usuário não encontrado no banco"
      end

      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      flash[:welcome_message] = "Bem-vindo de volta, #{current_user.full_name}!" if is_navigational_format?
      respond_with resource, location: after_sign_in_path_for(resource)
    rescue => e
      Rails.logger.error "==== Erro ao tentar logar ===="
      Rails.logger.error "Mensagem: #{e.message}"
      Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
      
      handle_authentication_error(e)
    end
  end

  def destroy
    sign_out(current_user)
    flash[:notice] = "Logout realizado com sucesso."
    redirect_to root_path
  end

  def after_sign_in_path_for(resource)
    admin_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  private

  def log_request_info
    Rails.logger.info "==== Informações da Requisição ===="
    Rails.logger.info "Controller: #{controller_name}"
    Rails.logger.info "Action: #{action_name}"
    Rails.logger.info "Format: #{request.format}"
    Rails.logger.info "Path: #{request.path}"
    Rails.logger.info "=================================="
  end

  def handle_authentication_error(error)
    Rails.logger.error "==== Erro de autenticação DETALHADO ===="
    Rails.logger.error "Mensagem: #{error.message}"
    Rails.logger.error "Backtrace: #{error.backtrace.join("\n")}"
    
    respond_to do |format|
      format.html do
        flash[:alert] = "Email ou senha inválidos. Por favor, verifique suas credenciais."
        redirect_to new_session_path(resource_name)
      end
      format.json { render json: { error: "Email ou senha inválidos" }, status: :unauthorized }
    end
  end

  def handle_standard_error(error)
    respond_to do |format|
      format.html do
        flash[:alert] = "Erro ao tentar logar: #{error.message}"
        redirect_to new_session_path(resource_name) and return
      end
      format.json { 
        render json: { error: "Erro ao tentar logar: #{error.message}" }, 
        status: :unprocessable_entity 
      }
    end
  end
end
