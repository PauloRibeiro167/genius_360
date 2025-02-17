class CreatePerfilPermissionsController < ApplicationController
  before_action :set_create_perfil_permission, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Create perfil permission", root_path
    @q = CreatePerfilPermission.ransack(params[:q])
    @create_perfil_permissions = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Create perfil permissions", create_perfil_permissions_path
    add_breadcrumb "Visualizar create perfil permission", create_perfil_permission_path(@create_perfil_permission)
  end

  def new
    add_breadcrumb "Create perfil permissions", create_perfil_permissions_path
    add_breadcrumb "Novo", new_create_perfil_permission_path
    @create_perfil_permission = CreatePerfilPermission.new
  end

  def edit
    add_breadcrumb "Create perfil permissions", create_perfil_permissions_path
    add_breadcrumb "Editar create perfil permission", edit_create_perfil_permission_path(@create_perfil_permission)
  end

  def create
    @create_perfil_permission = CreatePerfilPermission.new(create_perfil_permission_params)

    if @create_perfil_permission.save
      redirect_to @create_perfil_permission, notice: "Create perfil permission foi criado com sucesso."
    else
      add_breadcrumb "Novo create perfil permission", new_create_perfil_permission_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @create_perfil_permission.update(create_perfil_permission_params)
      redirect_to @create_perfil_permission, notice: "Create perfil permission foi atualizado com sucesso."
    else
      add_breadcrumb "Editar create perfil permission", edit_create_perfil_permission_path(@create_perfil_permission)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @create_perfil_permission.destroy!
    redirect_to create_perfil_permissions_url, notice: "Create perfil permission foi apagado com sucesso.", status: :see_other
  end

  def discard
    @create_perfil_permission = CreatePerfilPermission.find(params[:id])
    @create_perfil_permission.destroy

    respond_to do |format|
      format.html { redirect_to create_perfil_permissions_url, notice: "Permissão de perfil excluída com sucesso." }
    end
  end

  def undiscard
    @create_perfil_permission.undiscard
    redirect_to create_perfil_permissions_path, notice: "Create perfil permission reativado com sucesso."
  end

  private
    def set_create_perfil_permission
      @create_perfil_permission = CreatePerfilPermission.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def create_perfil_permission_params
      params.require(:create_perfil_permission).permit(:perfil_id, :permission_id)
    end
end
