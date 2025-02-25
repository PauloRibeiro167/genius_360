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
