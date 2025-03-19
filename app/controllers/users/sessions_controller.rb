class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :verify_signed_out_user, only: [:create]
  before_action :log_request_info
  respond_to :html, :json, :turbo_stream

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
    begin
      render "devise/sessions/new"
    rescue => e
      flash[:alert] = "Erro ao carregar página de login. Por favor, tente novamente."
      redirect_to root_path
    end
  end

  def create
    begin
      user = User.find_by(email: params[:user][:email])
      
      if user
        valid_password = user.valid_password?(params[:user][:password])
        
        if (user.respond_to?(:public_user?) && user.public_user?) || valid_password
          sign_in(resource_name, user)  
          set_flash_message!(:notice, :signed_in)
          flash[:welcome_message] = "Bem-vindo de volta, #{user.full_name}!" if is_navigational_format?
          return respond_with user, location: after_sign_in_path_for(user)
        else
          handle_failed_authentication
          return
        end
      else
        handle_failed_authentication
        return
      end

      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      flash[:welcome_message] = "Bem-vindo de volta, #{current_user.full_name}!" if is_navigational_format?
      respond_with resource, location: after_sign_in_path_for(resource)
    rescue Warden::AuthenticationError => e
      handle_failed_authentication
    rescue => e
      handle_standard_error(e)
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
  end

  def handle_authentication_error(error)
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

  def handle_failed_authentication
    flash[:alert] = "Email ou senha inválidos"
    respond_to do |format|
      format.html { redirect_to new_user_session_path }
      format.json { render json: { error: "Credenciais inválidas" }, status: :unauthorized }
    end
  end
end
