class Admin::ProfileController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(user_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Perfil atualizado com sucesso!"
          render turbo_stream: [
            turbo_stream.update("flash-messages",
              partial: "shared/flash_messages",
              locals: { flash: flash })
          ]
        end
      end
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_contacts
    if current_user.update(contact_params)
      render json: { message: 'Contatos atualizados com sucesso' }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_password
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      render json: { message: 'Senha atualizada com sucesso' }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, 
      :email, 
      :first_name, 
      :last_name, 
      :username,
      :phone  
    )
  end

  def contact_params
    params.require(:user).permit(
      :phone, 
      :mobile, 
      :address
    )
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
