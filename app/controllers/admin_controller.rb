class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_permission

  private

  def check_admin_permission
    return if current_user&.admin?

    flash[:alert] = "Você não possui permissão para acessar esta área."
    redirect_to root_path
  end
end
