class Admin::PropostasController < ApplicationController
  layout "kanban"
  def consulta_servidor
    # Action para exibir o formulário de consulta
  end

  def buscar_servidor
    cpf = params[:cpf]
    
    if cpf.present?
      serv_federal = ServFederalController.new
      @resultado = serv_federal.fetch_data(1) # Página inicial = 1
      
      if @resultado.nil?
        flash[:error] = "Nenhum dado encontrado para o CPF informado."
      end
    else
      flash[:error] = "Por favor, informe um CPF válido."
    end

    render :consulta_servidor
  end

  def selecionar_consulta
    @tipos_consulta = [
      ['Servidores Federais', 'servidores_federais'],
      ['Servidores do Piauí', 'servidores_pi'],
      ['Servidores do Ceará', 'servidores_ce'],
      ['Benefícios Previdenciários', 'beneficios_previdenciarios']
    ]
  end

  def redirecionar_consulta
    case params[:tipo_consulta]
    when 'servidores_federais'
      redirect_to consulta_servidores_federais_admin_propostas_path
    when 'servidores_pi'
      redirect_to consulta_servidores_pi_admin_propostas_path
    when 'servidores_ce'
      redirect_to consulta_servidores_ce_admin_propostas_path
    when 'beneficios_previdenciarios'
      redirect_to consulta_beneficios_admin_propostas_path
    else
      redirect_to admin_propostas_path, alert: 'Tipo de consulta inválido'
    end
  end

  def show
    if params[:id] == 'novo'
      redirect_to new_admin_proposta_path
    else
      @proposta = ::Proposta.find(params[:id])
    end
  end

  def new
    @proposta = ::Proposta.new
  end
end
