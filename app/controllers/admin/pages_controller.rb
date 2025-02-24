class Admin::PagesController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def settings
  end

  def update_profile
    if current_user.update(user_params)
      redirect_to admin_settings_path, notice: 'Perfil atualizado com sucesso!'
    else
      redirect_to admin_settings_path, alert: 'Erro ao atualizar perfil.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :phone, :avatar)
  end
end
