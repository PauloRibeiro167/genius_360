module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin

    private

    def verify_admin
      unless current_user&.admin?
        flash[:alert] = "Acesso não autorizado."
        redirect_to root_path
      end
    end
  end
end
