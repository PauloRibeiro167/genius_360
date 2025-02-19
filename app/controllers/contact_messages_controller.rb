class ContactMessagesController < ApplicationController
  before_action :set_contact_message, only: %i[ show edit update destroy discard undiscard ]

  def index
    add_breadcrumb "Contact message", root_path
    @q = ContactMessage.ransack(params[:q])
    @contact_messages = @q.result.page(params[:page]).per(10)
    @page = params[:page].to_i || 1
  end

  def show
    add_breadcrumb "Contact messages", contact_messages_path
    add_breadcrumb "Visualizar contact message", contact_message_path(@contact_message)
  end

  def new
    add_breadcrumb "Contact messages", contact_messages_path
    add_breadcrumb "Novo", new_contact_message_path
    @contact_message = ContactMessage.new
  end

  def edit
    add_breadcrumb "Contact messages", contact_messages_path
    add_breadcrumb "Editar contact message", edit_contact_message_path(@contact_message)
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      redirect_to @contact_message, notice: "Contact message foi criado com sucesso."
    else
      add_breadcrumb "Novo contact message", new_contact_message_path
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @contact_message.update(contact_message_params)
      redirect_to @contact_message, notice: "Contact message foi atualizado com sucesso."
    else
      add_breadcrumb "Editar contact message", edit_contact_message_path(@contact_message)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_message.destroy!
    redirect_to contact_messages_url, notice: "Contact message foi apagado com sucesso.", status: :see_other
  end

  def discard
    @contact_message.discard
    redirect_to contact_messages_path, notice: "Contact message desativado com sucesso."
  end

  def undiscard
    @contact_message.undiscard
    redirect_to contact_messages_path, notice: "Contact message reativado com sucesso."
  end

  private
    def set_contact_message
      @contact_message = ContactMessage.find(params[:id])
    end

    def page_params
      params[:page]
    end

    def contact_message_params
      params.require(:contact_message).permit(:name, :email, :message, :status)
    end
end
