class PerfilUsersController < ApplicationController
  before_action :set_perfil_user, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Perfil user", root_path
    @q = PerfilUser.ransack(params[:q])
    @perfil_users = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Perfil users", perfil_users_path
    add_breadcrumb "Visualizar perfil user", perfil_user_path(@perfil_user)
  end

  def new
    add_breadcrumb "Perfil users", perfil_users_path
    add_breadcrumb "Novo", new_perfil_user_path
    @perfil_user = PerfilUser.new
  end

  def edit
    add_breadcrumb "Perfil users", perfil_users_path
    add_breadcrumb "Editar perfil user", edit_perfil_user_path(@perfil_user)
  end

  def create
    @perfil_user = PerfilUser.new(perfil_user_params)

    if @perfil_user.save
      redirect_to @perfil_user, notice: "Perfil user foi criado com sucesso."
    else
      add_breadcrumb "Novo perfil user", new_perfil_user_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @perfil_user.update(perfil_user_params)
      redirect_to @perfil_user, notice: "Perfil user foi atualizado com sucesso."
    else
      add_breadcrumb "Editar perfil user", edit_perfil_user_path(@perfil_user)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @perfil_user.destroy!
    redirect_to perfil_users_url, notice: "Perfil user foi apagado com sucesso.", status: :see_other
  end

  def discard
    @perfil_user.discard
    redirect_to perfil_users_path, notice: "Perfil user desativado com sucesso."
  end

  def undiscard
    @perfil_user.undiscard
    redirect_to perfil_users_path, notice: "Perfil user reativado com sucesso."
  end

  private
    def set_perfil_user
      @perfil_user = PerfilUser.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def perfil_user_params
      params.require(:perfil_user).permit(:user_id, :perfil_id)
    end
end
