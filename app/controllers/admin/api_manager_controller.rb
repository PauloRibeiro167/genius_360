class Admin::ApiManagerController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin_permission
    
    def start
      controller = MainController.new
      controller.start
      
      flash[:notice] = 'API iniciada com sucesso!'
      redirect_to admin_dashboard_index_path
    rescue StandardError => e
      flash[:alert] = "Erro ao iniciar API: #{e.message}"
      redirect_to admin_dashboard_index_path
    end
    
    def status
      # Implemente aqui a lógica para verificar o status da API
      # Exemplo:
      # @status = ApiService.status
      
      render json: { status: 'API ativa', last_run: Time.current }
    end

    private

    def check_admin_permission
      return if current_user&.admin?

      flash[:alert] = 'Você não possui permissão para esta ação.'
      redirect_to root_path
    end
  end
end
