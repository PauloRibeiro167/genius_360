module Admin
  class ReunioesController < BaseController
    def index
      start_date = params[:start]
      end_date = params[:end]

      @reunioes = Reuniao.where(data: start_date..end_date)

      render json: @reunioes
    end

    def create
      @reuniao = Reuniao.new(reuniao_params)

      # Processa os usuários selecionados
      if params[:reuniao][:user_ids].present?
        @reuniao.user_ids = params[:reuniao][:user_ids].split(",")
      end

      if @reuniao.save
        redirect_to admin_comunicados_path, notice: "Reunião criada com sucesso!"
      else
        redirect_to admin_comunicados_path, alert: "Erro ao criar reunião."
      end
    end

    private

    def reuniao_params
      params.require(:reuniao).permit(:titulo, :descricao, :data, user_ids: [])
    end
  end
end
