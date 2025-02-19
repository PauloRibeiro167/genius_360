class Devise::SessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def create
    self.resource = warden.authenticate!(auth_options)

    if resource.persisted?
      Rails.logger.info "Usuário autenticado com sucesso: #{resource.email}"
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)

      respond_to do |format|
        format.turbo_stream { redirect_to after_sign_in_path_for(resource) }
        format.html { redirect_to after_sign_in_path_for(resource) }
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
