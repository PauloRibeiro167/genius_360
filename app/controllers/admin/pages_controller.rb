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
    @users = if params[:search].present?
      User.where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
          .where.not(id: current_user.id)
    end

    @all_conversations = Message.select('DISTINCT ON (LEAST(user_id, recipient_id), GREATEST(user_id, recipient_id)) *')
                              .where('user_id = ? OR recipient_id = ?', current_user.id, current_user.id)
                              .order('LEAST(user_id, recipient_id), GREATEST(user_id, recipient_id), created_at DESC')
                              .map { |m| m.user_id == current_user.id ? m.recipient : m.user }
                              .uniq

    if params[:recipient_id].present?
      @recipient = User.find(params[:recipient_id])
      @messages = Message.conversation_between(current_user, @recipient)
                        .order(created_at: :asc)
      
      # Marcar mensagens como lidas
      Message.where(user_id: @recipient.id, recipient_id: current_user.id, read_at: nil)
            .update_all(read_at: Time.current)
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
