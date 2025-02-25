class Devise::SessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def create
    Rails.logger.info "==== Iniciando processo de login ===="
    Rails.logger.info "Parâmetros recebidos: #{params.inspect}"

    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      Rails.logger.info "Usuário autenticado com sucesso: #{user.email}"
      flash[:notice] = "Login efetuado com sucesso."
      sign_in(resource_name, user)

      respond_to do |format|
        format.turbo_stream { redirect_to admin_root_path }
        format.html { redirect_to admin_root_path }
        format.json { render json: { success: true }, status: :ok }
      end
    else
      Rails.logger.error "Falha na autenticação para email: #{params[:user][:email]}"
      respond_to do |format|
        format.turbo_stream {
          flash[:alert] = "Email ou senha inválidos."
          redirect_to new_user_session_path
        }
        format.html {
          flash[:alert] = "Email ou senha inválidos."
          redirect_to new_user_session_path
        }
        format.json { render json: { error: "Credenciais inválidas" }, status: :unauthorized }
      end
    end
  end

  private

  def resource
    @resource ||= User.new
  end

  def resource_name
    :user
  end

  helper_method :resource, :resource_name
end
