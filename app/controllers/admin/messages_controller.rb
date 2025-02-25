class Admin::MessagesController < ApplicationController
  def create
    @message = current_user.sent_messages.build(message_params)
    
    if @message.save
      # Notificar o destinatário usando noticed
      MessageNotification.with(message: @message).deliver(@message.recipient)
      
      # Broadcast em tempo real
      html = ApplicationController.render(
        partial: 'admin/messages/message',
        locals: { message: @message }
      )
      ActionCable.server.broadcast("chat_#{@message.recipient_id}", html)
      
      # Resposta para o remetente
      respond_to do |format|
        format.turbo_stream
        format.html { 
          redirect_to mensagens_admin_pages_path(recipient_id: @message.recipient_id) 
        }
      end
    else
      # Tratamento de erro
      redirect_to mensagens_admin_pages_path(recipient_id: params[:message][:recipient_id]), 
                  alert: "Erro ao enviar mensagem"
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:content, :recipient_id)
  end
end

class Message < ApplicationRecord
  include Discard::Model
  
  belongs_to :user
  belongs_to :recipient, class_name: 'User'
  
  validates :content, presence: true
  
  scope :unread, -> { where(read: false) }
  scope :between_users, ->(user_id, recipient_id) { 
    where("(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)", 
          user_id, recipient_id, recipient_id, user_id)
  }
end
