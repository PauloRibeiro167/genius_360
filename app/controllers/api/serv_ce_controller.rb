module Api
  class ServCeController < BaseController
    def index
      @servidores = ServidorCe.all
      render json: @servidores
    end

    def show
      @servidor = ServidorCe.find(params[:id])
      render json: @servidor
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Servidor não encontrado" }, status: :not_found
    end

    def search
      @servidores = ServidorCe.where("nome ILIKE ?", "%#{params[:q]}%")
      render json: @servidores
    end

    private

    def servidor_params
      params.require(:servidor).permit(:nome, :matricula, :cargo, :orgao)
    end
  end
end
