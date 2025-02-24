class PerfilPermissionsController < ApplicationController
  before_action :set_perfil_permission, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "perfil permission", root_path
    @q = PerfilPermission.ransack(params[:q])
    @perfil_permissions = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "perfil permissions", perfil_permissions_path
    add_breadcrumb "Visualizar perfil permission", perfil_permission_path(@perfil_permission)
  end

  def new
    add_breadcrumb "perfil permissions", perfil_permissions_path
    add_breadcrumb "Novo", new_perfil_permission_path
    @perfil_permission = PerfilPermission.new
  end

  def edit
    add_breadcrumb "perfil permissions", perfil_permissions_path
    add_breadcrumb "Editar perfil permission", edit_perfil_permission_path(@perfil_permission)
  end

  def create
    @perfil_permission = PerfilPermission.new(perfil_permission_params)

    if @perfil_permission.save
      redirect_to @perfil_permission, notice: "perfil permission foi criado com sucesso."
    else
      add_breadcrumb "Nova perfil permission", new_perfil_permission_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @perfil_permission.update(perfil_permission_params)
      redirect_to @perfil_permission, notice: "perfil permission foi atualizado com sucesso."
    else
      add_breadcrumb "Editar perfil permission", edit_perfil_permission_path(@perfil_permission)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @perfil_permission.destroy!
    redirect_to perfil_permissions_url, notice: "perfil permission foi apagado com sucesso.", status: :see_other
  end

  def discard
    @perfil_permission = PerfilPermission.find(params[:id])
    @perfil_permission.destroy

    respond_to do |format|
      format.html { redirect_to perfil_permissions_url, notice: "Permissão de perfil excluída com sucesso." }
    end
  end

  def undiscard
    @perfil_permission.undiscard
    redirect_to perfil_permissions_path, notice: "perfil permission reativado com sucesso."
  end

  private
    def set_perfil_permission
      @perfil_permission = PerfilPermission.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def perfil_permission_params
      params.require(:perfil_permission).permit(:perfil_id, :permission_id)
    end
end
