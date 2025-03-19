class Admin::PropostasController < AdminController
  before_action :set_proposta, only: [:show, :edit, :update, :next_step, :previous_step]
  layout "kanban"
  
  def consulta_servidor
  end

  def buscar_servidor
    @cpf = params[:cpf]
    
    if @cpf.present?
      # Remove caracteres não numéricos
      @cpf = @cpf.gsub(/[^0-9]/, '')
      
      # Valida formato do CPF
      if @cpf.length == 11
        # Acessa o serviço federal
        serv_federal = ServFederalService.new
        @resultado = serv_federal.fetch_data_by_cpf(@cpf)
        
        # Salva os dados se encontrados
        if @resultado.present?
          serv_federal.save_data(@resultado)
        else
          flash[:error] = "Não foi possível encontrar dados para este CPF"
        end
      else
        flash[:error] = "CPF inválido. Por favor, digite um CPF com 11 dígitos."
      end
    else
      flash[:error] = "Por favor, forneça um CPF para consulta"
    end
    
    render 'consulta_servidor'
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

  def edit
    # O método set_proposta já definiu @proposta
  end

  def new
    @proposta = ::Proposta.new
  end

  def search_users
    @users = if params[:query].present?
      User.where("name ILIKE :query OR cpf ILIKE :query OR email ILIKE :query", 
                  query: "%#{params[:query]}%")
    else
      User.none
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to selecionar_consulta_admin_propostas_path }
    end
  end

  def index
    @propostas = Proposta.all
    apply_prazo_filters if params[:prazo_tipo].present?
  end
  
  def filter_by_prazo
    @propostas = Proposta.all
    apply_prazo_filters
    
    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end
  
  def update
    if @proposta.update(proposta_params)
      redirect_to admin_proposta_path(@proposta), notice: "Proposta atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @proposta.destroy
      redirect_to admin_propostas_path, notice: "Proposta excluída com sucesso."
    else
      redirect_to admin_proposta_path(@proposta), alert: "Não foi possível excluir a proposta."
    end
  end

  def next_step
    current_step = @proposta.current_step || 0
    next_step = current_step + 1
    
    if @proposta.update(current_step: next_step)
      redirect_to edit_admin_proposta_path(@proposta), notice: "Avançou para a próxima etapa."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def previous_step
    current_step = @proposta.current_step || 0
    previous_step = [current_step - 1, 0].max
    
    if @proposta.update(current_step: previous_step)
      redirect_to edit_admin_proposta_path(@proposta), notice: "Retornou para a etapa anterior."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def apply_prazo_filters
    case params[:prazo_tipo]
    when 'em_dia'
      @propostas = @propostas.where('data_vencimento_contrato > ?', Date.today)
    when 'proximo_vencimento'
      @propostas = @propostas.where('data_vencimento_contrato BETWEEN ? AND ?', Date.today, 30.days.from_now)
    when 'vencido'
      @propostas = @propostas.where('data_vencimento_contrato < ?', Date.today)
    when 'personalizado'
      if params[:data_inicial].present? && params[:data_final].present?
        data_inicial = Date.parse(params[:data_inicial])
        data_final = Date.parse(params[:data_final])
        @propostas = @propostas.where('data_vencimento_contrato BETWEEN ? AND ?', data_inicial, data_final)
      end
    end
  end
  
  def set_proposta
    @proposta = Proposta.find(params[:id])
  end
  
  def proposta_params
    params.require(:proposta).permit(
      :cliente_id, :status, :current_step, :data_vencimento_contrato,
    )
  end
end