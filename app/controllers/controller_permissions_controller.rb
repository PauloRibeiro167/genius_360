class ControllerPermissionsController < ApplicationController
  before_action :set_controller_permission, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Controller permission", root_path
    @q = ControllerPermission.ransack(params[:q])
    @controller_permissions = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Controller permissions", controller_permissions_path
    add_breadcrumb "Visualizar controller permission", controller_permission_path(@controller_permission)
  end

  def new
    add_breadcrumb "Controller permissions", controller_permissions_path
    add_breadcrumb "Novo", new_controller_permission_path
    @controller_permission = ControllerPermission.new
  end

  def edit
    add_breadcrumb "Controller permissions", controller_permissions_path
    add_breadcrumb "Editar controller permission", edit_controller_permission_path(@controller_permission)
  end

  def create
    @controller_permission = ControllerPermission.new(controller_permission_params)

    if @controller_permission.save
      redirect_to @controller_permission, notice: "Controller permission foi criado com sucesso."
    else
      add_breadcrumb "Novo controller permission", new_controller_permission_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @controller_permission.update(controller_permission_params)
      redirect_to @controller_permission, notice: "Controller permission foi atualizado com sucesso."
    else
      add_breadcrumb "Editar controller permission", edit_controller_permission_path(@controller_permission)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @controller_permission.destroy!
    redirect_to controller_permissions_url, notice: "Controller permission foi apagado com sucesso.", status: :see_other
  end

  def discard
    @controller_permission.discard
    redirect_to controller_permissions_path, notice: "Controller permission desativado com sucesso."
  end

  def undiscard
    @controller_permission.undiscard
    redirect_to controller_permissions_path, notice: "Controller permission reativado com sucesso."
  end

  private
    def set_controller_permission
      @controller_permission = ControllerPermission.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def controller_permission_params
      params.require(:controller_permission).permit(:name)
    end
end
