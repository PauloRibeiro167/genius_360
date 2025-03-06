class Admin::PagesController < ApplicationController
  layout "kanban"
  before_action :authenticate_user!

  def index

  end

  def settings
  end

  def update_profile
    if current_user.update(user_params)
      redirect_to admin_pages_settings_path, notice: 'Perfil atualizado com sucesso!'
    else
      redirect_to admin_pages_settings_path, alert: 'Erro ao atualizar perfil.'
    end
  end

  def filter
  end

  def proposta
  end

  def mensagens
    @recipient = User.find(params[:recipient_id]) if params[:recipient_id]
    
    if params[:search].present?
      @users = User.where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
                  .where.not(id: current_user.id)
    end

    # Busca todas as conversas do usuário
    @all_conversations = User.joins(
      "INNER JOIN messages ON messages.sender_id = users.id OR messages.recipient_id = users.id"
    ).where(
      "messages.sender_id = :user_id OR messages.recipient_id = :user_id", 
      user_id: current_user.id
    ).where.not(
      id: current_user.id
    ).distinct

    # Se há um destinatário selecionado, busca as mensagens da conversa
    @messages = Message.conversation_between(current_user.id, @recipient.id)
                      .includes(:sender, :recipient)
                      .order(created_at: :asc) if @recipient
  end

  def comunicados
    @avisos = Aviso.order(created_at: :desc)
    @reunioes = Reuniao.order(data: :desc)
    @aviso = Aviso.new
    @reuniao = Reuniao.new
    @users = User.order(:name) # Adicione esta linha para carregar os usuários ordenados por nome
  end

  def results
    @filters = params[:filters] || {}
    @results = Lead.where(@filters)

    respond_to do |format|
      format.html
      format.csv { send_data @results.to_csv, filename: "leads-#{Date.today}.csv" }
    end
  end

  def import_csv
    DynamicCsvImportService.new(params[:file]).import
    redirect_to admin_pages_results_path, notice: "CSV importado com sucesso!"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :phone, :avatar)
  end
end
