module Admin
  class UsersController < Admin::BaseController
    def search
      @users = User.where("name ILIKE ?", "%#{params[:q]}%")
                  .order(:name)
                  .limit(10)

      render json: @users.map { |user| { id: user.id, text: user.name } }
    end

    def check_cpf
      exists = User.exists?(cpf: params[:cpf])
      render json: { exists: exists }
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :cpf, :phone, :admin)
    end
  end
end
