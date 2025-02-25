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
    # Carregar todos os usuários, exceto o usuário atual, para o seletor
    @users = User.kept.where.not(id: current_user.id).order(:name)
    
    # Verificar se um destinatário foi selecionado
    if params[:recipient_id].present?
      @recipient = User.find(params[:recipient_id])
      
      # Obter mensagens entre o usuário atual e o destinatário
      @messages = Message.kept
                        .between_users(current_user.id, @recipient.id)
                        .order(created_at: :asc)
    else
      # Nenhum destinatário selecionado ainda
      @messages = Message.none
    end
  end

  def notificacoes
    @messages = Message.includes(:user).order(created_at: :asc)
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
