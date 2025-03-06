module Admin
  class ProfileController < AdminController
    before_action :authenticate_user!

    def update
      if current_user.update(user_params)
        flash[:notice] = "Perfil atualizado com sucesso!"
      else
        flash[:error] = "Erro ao atualizar perfil"
      end
      redirect_to admin_settings_path
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
        flash[:notice] = "Senha atualizada com sucesso!"
        bypass_sign_in(current_user)
      else
        flash[:error] = "Erro ao atualizar senha"
      end
      redirect_to admin_settings_path
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :phone, :avatar)
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
end
