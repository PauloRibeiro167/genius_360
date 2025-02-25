class Admin::MessagesController < AdminController
  def create
    @message = current_user.messages.build(message_params)
    
    if @message.save
      MessageNotification.with(message: @message).deliver_later(@message.recipient)
      respond_to do |format|
        format.html { redirect_to mensagens_admin_pages_path(recipient_id: @message.recipient_id) }
        format.json { render json: @message, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to mensagens_admin_pages_path(recipient_id: @message.recipient_id), alert: 'Erro ao enviar mensagem.' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
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
