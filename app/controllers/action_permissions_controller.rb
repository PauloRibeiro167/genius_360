class ActionPermissionsController < ApplicationController
  before_action :set_action_permission, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Action permission", root_path
    @q = ActionPermission.ransack(params[:q])
    @action_permissions = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Action permissions", action_permissions_path
    add_breadcrumb "Visualizar action permission", action_permission_path(@action_permission)
  end

  def new
    add_breadcrumb "Action permissions", action_permissions_path
    add_breadcrumb "Novo", new_action_permission_path
    @action_permission = ActionPermission.new
  end

  def edit
    add_breadcrumb "Action permissions", action_permissions_path
    add_breadcrumb "Editar action permission", edit_action_permission_path(@action_permission)
  end

  def create
    @action_permission = ActionPermission.new(action_permission_params)

    if @action_permission.save
      redirect_to @action_permission, notice: "Action permission foi criado com sucesso."
    else
      add_breadcrumb "Novo action permission", new_action_permission_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @action_permission.update(action_permission_params)
      redirect_to @action_permission, notice: "Action permission foi atualizado com sucesso."
    else
      add_breadcrumb "Editar action permission", edit_action_permission_path(@action_permission)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @action_permission.destroy!
    redirect_to action_permissions_url, notice: "Action permission foi apagado com sucesso.", status: :see_other
  end

  def discard
    @action_permission = ActionPermission.find(params[:id])
    if @action_permission.discard
      redirect_to action_permissions_path, notice: "Registro excluído com sucesso."
    else
      redirect_to action_permissions_path, alert: "Erro ao excluir o registro."
    end
  end

  def undiscard
    @action_permission = ActionPermission.find(params[:id])
    if @action_permission.undiscard
      redirect_to action_permissions_path, notice: "Registro restaurado com sucesso."
    else
      redirect_to action_permissions_path, alert: "Erro ao restaurar o registro."
    end
  end

  private
    def set_action_permission
      @action_permission = ActionPermission.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def action_permission_params
      params.require(:action_permission).permit(:name)
    end
end
