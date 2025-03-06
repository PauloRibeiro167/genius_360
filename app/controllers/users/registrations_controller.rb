class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :verify_admin_access, only: [:new, :create]
  respond_to :html, :turbo_stream

  private

  # def verify_admin_access
  #   unless current_user&.admin?
  #     flash[:alert] = "Acesso negado. Apenas administradores podem cadastrar novos usuários."
  #     redirect_to root_path
  #   end
  # end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :cpf, :password, :password_confirmation, :perfil_id)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :cpf, :password, :password_confirmation, :current_password, :perfil_id)
  end

  protected

  def after_sign_up_path_for(resource)
    admin_dashboard_index_path
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      flash[:notice] = "Conta criada com sucesso."
      redirect_to after_sign_up_path_for(resource)
    else
      begin
        flash.now[:alert] = resource.errors.full_messages.join(", ")
        respond_to do |format|
          format.turbo_stream { 
            render turbo_stream: turbo_stream.replace(
              "new_user",
              template: "devise/registrations/new",
              locals: { resource: resource }
            )
          }
          format.html { 
            render :new, status: :unprocessable_entity
          }
        end
      rescue StandardError => e
        flash.now[:error] = "Ocorreu um erro inesperado: #{e.message}"
        respond_to do |format|
          format.html { render :new, status: :internal_server_error }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("new_user", partial: "shared/error") }
        end
      end
    end
  end
end
