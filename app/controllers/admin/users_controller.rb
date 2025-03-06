module Admin
  class UsersController < Admin::BaseController
    def search
      @users = User.where("name ILIKE ?", "%#{params[:q]}%")
                  .order(:name)
                  .limit(10)

      render json: @users.map { |user| { id: user.id, text: user.name } }
    end
  end
end
