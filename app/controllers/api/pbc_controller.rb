module Api
  class PbcController < BaseController
    def index
      @pbcs = Pbc.all
      render json: @pbcs
    end

    def show
      @pbc = Pbc.find(params[:id])
      render json: @pbc
    rescue ActiveRecord::RecordNotFound
      render json: { error: "PBC não encontrado" }, status: :not_found
    end

    private

    def pbc_params
      params.require(:pbc).permit(:title, :description, :status)
    end
  end
end
