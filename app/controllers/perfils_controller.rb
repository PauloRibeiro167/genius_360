class PerfilsController < ApplicationController
  before_action :set_perfil, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Perfil", root_path
    @q = Perfil.ransack(params[:q])
    @perfils = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Perfils", perfils_path
    add_breadcrumb "Visualizar perfil", perfil_path(@perfil)
  end

  def new
    add_breadcrumb "Perfils", perfils_path
    add_breadcrumb "Novo", new_perfil_path
    @perfil = Perfil.new
  end

  def edit
    add_breadcrumb "Perfils", perfils_path
    add_breadcrumb "Editar perfil", edit_perfil_path(@perfil)
  end

  def create
    @perfil = Perfil.new(perfil_params)

    if @perfil.save
      redirect_to @perfil, notice: "Perfil foi criado com sucesso."
    else
      add_breadcrumb "Novo perfil", new_perfil_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @perfil.update(perfil_params)
      redirect_to @perfil, notice: "Perfil foi atualizado com sucesso."
    else
      add_breadcrumb "Editar perfil", edit_perfil_path(@perfil)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @perfil.destroy!
    redirect_to perfils_url, notice: "Perfil foi apagado com sucesso.", status: :see_other
  end

  def discard
    @perfil.discard
    redirect_to perfils_path, notice: "Perfil desativado com sucesso."
  end

  def undiscard
    @perfil.undiscard
    redirect_to perfils_path, notice: "Perfil reativado com sucesso."
  end

  private
    def set_perfil
      @perfil = Perfil.with_discarded.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def perfil_params
      params.require(:perfil).permit(:name)
    end
end
