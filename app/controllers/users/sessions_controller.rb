class Users::SessionsController < Devise::SessionsController
  include DeviseHelper
  before_action :configure_sign_in_params, only: [ :create ]
  before_action :verify_signed_out_user, only: [ :new, :create ]
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
    begin
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_to do |format|
        format.html { redirect_to after_sign_in_path_for(resource) }
        format.json { render json: { message: "Logado com sucesso" }, status: :ok }
      end
    rescue Warden::Errors::AuthenticationError => e
      handle_authentication_error(e)
    rescue StandardError => e
      handle_standard_error(e)
    end
  end

  def destroy
    Rails.logger.info "==== Logout ===="
    Rails.logger.info "Usuário: #{current_user&.email}"
    Rails.logger.info "Timestamp: #{Time.current}"
    super
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password, :remember_me ])
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def sign_in_params
    params.require(:user).permit(:email, :password)
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
    respond_to do |format|
      format.html do
        flash[:alert] = "Email ou senha inválidos."
        redirect_to new_session_path(resource_name)
      end
      format.json { render json: { error: "Email ou senha inválidos." }, status: :unauthorized }
    end
  end

  def handle_standard_error(error)
    respond_to do |format|
      format.html do
        flash[:alert] = "Erro ao tentar logar: #{error.message}"
        redirect_to new_session_path(resource_name)
      end
      format.json { render json: { error: "Erro ao tentar logar: #{error.message}" }, status: :unprocessable_entity }
    end
  end
end
