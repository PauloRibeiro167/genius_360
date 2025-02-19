class Users::RegistrationsController < Devise::RegistrationsController
  # Remover ou ajustar esta linha se existir
  # before_action :require_admin

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :profile)
  end
end
