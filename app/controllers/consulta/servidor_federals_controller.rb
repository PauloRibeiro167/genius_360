class Consulta::ServidorFederalsController < ApplicationController
  before_action :set_consulta_servidor_federal, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Servidor federal", root_path
    @q = Consulta::ServidorFederal.ransack(params[:q])
    @consulta_servidor_federals = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Servidor federals", consulta_servidor_federals_path
    add_breadcrumb "Visualizar servidor federal", consulta_servidor_federal_path(@consulta_servidor_federal)
  end

  def new
    add_breadcrumb "Servidor federals", consulta_servidor_federals_path
    add_breadcrumb "Novo", new_consulta_servidor_federal_path
    @consulta_servidor_federal = Consulta::ServidorFederal.new
  end

  def edit
    add_breadcrumb "Servidor federals", consulta_servidor_federals_path
    add_breadcrumb "Editar servidor federal", edit_consulta_servidor_federal_path(@consulta_servidor_federal)
  end

  def create
    @consulta_servidor_federal = Consulta::ServidorFederal.new(consulta_servidor_federal_params)

    if @consulta_servidor_federal.save
      redirect_to @consulta_servidor_federal, notice: "Servidor federal foi criado com sucesso."
    else
      add_breadcrumb "Novo servidor federal", new_consulta_servidor_federal_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @consulta_servidor_federal.update(consulta_servidor_federal_params)
      redirect_to @consulta_servidor_federal, notice: "Servidor federal foi atualizado com sucesso."
    else
      add_breadcrumb "Editar servidor federal", edit_consulta_servidor_federal_path(@consulta_servidor_federal)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @consulta_servidor_federal.destroy!
    redirect_to consulta_servidor_federals_url, notice: "Servidor federal foi apagado com sucesso.", status: :see_other
  end

  def discard
    @consulta_servidor_federal.discard
    redirect_to consulta_servidor_federals_path, notice: "Servidor federal desativado com sucesso."
  end

  def undiscard
    @consulta_servidor_federal.undiscard
    redirect_to consulta_servidor_federals_path, notice: "Servidor federal reativado com sucesso."
  end

  private
    def set_consulta_servidor_federal
      @consulta_servidor_federal = Consulta::ServidorFederal.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def consulta_servidor_federal_params
      params.require(:consulta_servidor_federal).permit(:cpf, :nome, :cargo, :orgao, :salario, :situacao, :tipo_servidor, :codigo_matricula_formatado, :flag_afastado, :orgao_lotacao_codigo, :orgao_lotacao_nome, :orgao_lotacao_sigla, :orgao_exercicio_codigo, :orgao_exercicio_nome, :orgao_exercicio_sigla, :estado_exercicio_sigla, :estado_exercicio_nome, :codigo_funcao_cargo, :descricao_funcao_cargo, :cpf_instituidor_pensao, :nome_instituidor_pensao, :cpf_representante_pensao, :nome_representante_pensao, :remuneracao_bruta, :remuneracao_apos_deducoes)
    end
end
