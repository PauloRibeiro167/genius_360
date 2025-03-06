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
    @contact_message.status = :solicitacao_contato  # Usando o símbolo correto do enum

    if @contact_message.save
      redirect_to root_path, notice: 'Mensagem enviada com sucesso!'
    else
      redirect_to contato_path, alert: 'Erro ao enviar mensagem.'
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
      params.require(:contact_message).permit(:name, :email, :phone, :message, :request_type)
    end
end
