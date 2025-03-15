class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_user!
  before_action :check_super_admin
  skip_before_action :require_no_authentication
  respond_to :html, :turbo_stream

  private

  def check_super_admin
    unless user_signed_in? && current_user.perfil&.name == 'Super Admin'
      Rails.logger.warn "Tentativa de acesso não autorizado ao registro - IP: #{request.remote_ip}, Usuário: #{current_user&.email}"
      flash[:alert] = "Acesso permitido apenas para administradores do sistema."
      redirect_to root_path and return
    end
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :cpf, :password, :password_confirmation, :perfil_id)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :cpf, :password, :password_confirmation, :current_password, :perfil_id)
  end

  protected

  def sign_up(resource_name, resource)
    true
  end

  def after_sign_up_path_for(resource)
    admin_root_path
  end
end
