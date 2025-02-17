require "ostruct"

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone, :cpf, :perfil_id ])
  end

  private

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "Acesso permitido apenas para administradores."
      redirect_to root_path
    end
  end
end
