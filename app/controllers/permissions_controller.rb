class PermissionsController < ApplicationController
  before_action :set_permission, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Permission", root_path
    @q = Permission.ransack(params[:q])
    @permissions = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Permissions", permissions_path
    add_breadcrumb "Visualizar permission", permission_path(@permission)
  end

  def new
    add_breadcrumb "Permissions", permissions_path
    add_breadcrumb "Novo", new_permission_path
    @permission = Permission.new
  end

  def edit
    add_breadcrumb "Permissions", permissions_path
    add_breadcrumb "Editar permission", edit_permission_path(@permission)
  end

  def create
    @permission = Permission.new(permission_params)

    if @permission.save
      redirect_to @permission, notice: "Permission foi criado com sucesso."
    else
      add_breadcrumb "Novo permission", new_permission_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @permission.update(permission_params)
      redirect_to @permission, notice: "Permission foi atualizado com sucesso."
    else
      add_breadcrumb "Editar permission", edit_permission_path(@permission)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @permission.destroy!
    redirect_to permissions_url, notice: "Permission foi apagado com sucesso.", status: :see_other
  end

  def discard
    @permission.discard
    redirect_to permissions_path, notice: "Permission desativado com sucesso."
  end

  def undiscard
    @permission.undiscard
    redirect_to permissions_path, notice: "Permission reativado com sucesso."
  end

  private
    def set_permission
      @permission = Permission.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def permission_params
      params.require(:permission).permit(:name)
    end
end
