class Admin::AvisosController < ApplicationController
  def create
    @aviso = Aviso.new(aviso_params)
    if @aviso.save
      @aviso.user_ids = params[:aviso][:user_ids] if params[:aviso][:user_ids]
      redirect_to admin_comunicados_path, notice: 'Aviso criado com sucesso.'
    else
      redirect_to admin_comunicados_path, alert: 'Erro ao criar aviso.'
    end
  end

  private

  def aviso_params
    params.require(:aviso).permit(:titulo, :descricao, user_ids: [])
  end
end
