require "ostruct"

class ApplicationController < ActionController::Base
  # include AuthorizationConcern  
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern, 
                if: -> { browser.modern_browser?(browser) || browser.mobile? || Rails.env.development? }

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_authentication_status
  before_action :set_content_security_policy
  before_action :set_csp_for_fonts_and_maps
  before_action :set_welcome_message, if: :user_signed_in?

  protected

  def add_breadcrumb(name, path)
    @breadcrumbs ||= []
    @breadcrumbs << OpenStruct.new(name: name, path: path)
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end
  helper_method :breadcrumbs

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :cpf, :perfil_id])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end

  private

  def require_admin
    unless current_user&.admin?
      Rails.logger.info "Acesso negado para usuário: #{current_user&.email}"
      flash[:alert] = "Acesso permitido apenas para administradores."
      redirect_to root_path
    end
  end

  def verify_signed_out_user
    if current_user
      redirect_to root_path, notice: "Você já está logado."
    end
  end

  def log_authentication_status
    Rails.logger.info "===== Status de Autenticação ====="
    Rails.logger.info "Usuário atual: #{current_user&.email}"
    Rails.logger.info "Logado?: #{user_signed_in?}"
    Rails.logger.info "Admin?: #{current_user&.admin?}" if user_signed_in?
    Rails.logger.info "================================="
  end

  def set_content_security_policy
    response.headers['Content-Security-Policy'] = [
      "default-src 'self'",
      "style-src 'self' 'unsafe-inline' https:",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval' https:",
      "img-src 'self' data: https:",
      "font-src 'self' https:",
      "connect-src 'self' https:",
      "frame-src 'self'"
    ].join('; ')
  end

  def set_csp_for_fonts_and_maps
    # Override padrão do CSP para permitir fontes data: e frames do Google Maps
    SecureHeaders.override_content_security_policy_directives(request, 
      font_src: %w('self' https: data: 'unsafe-inline'),
      frame_src: %w('self' https://www.google.com https://*.google.com),
      style_src: %w('self' https: 'unsafe-inline')
    )
  end

  def set_welcome_message
    @show_welcome_message = false
    
    if session[:welcome_message_shown].nil? && user_signed_in?
      @show_welcome_message = true
      session[:welcome_message_shown] = true
    end
  end
end
