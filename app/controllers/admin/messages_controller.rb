class Admin::MessagesController < AdminController
  def index
    @messages = Message.all.order(created_at: :desc)
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      flash[:notice] = "Mensagem criada com sucesso!"
      redirect_to admin_messages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :content, :status)
  end
end

class Message < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :recipient, class_name: "User"

  validates :content, presence: true

  scope :unread, -> { where(read: false) }
  scope :between_users, ->(user_id, recipient_id) {
    where("(user_id = ? AND recipient_id = ?) OR (user_id = ? AND recipient_id = ?)",
          user_id, recipient_id, recipient_id, user_id)
  }
end
