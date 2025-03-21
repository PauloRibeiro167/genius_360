# app/models/notification.rb
class Notification < ApplicationRecord
  self.inheritance_column = nil  
  
  belongs_to :user
  
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :newest_first, -> { order(created_at: :desc) }
  
  validates :user, presence: true
  validates :type, presence: true
  validates :data, presence: true
  
  def mark_as_read!
    update(read_at: Time.current)
  end
  
  def read?
    read_at.present?
  end
  
  def unread?
    !read?
  end
  
  def content
    data&.dig('content')
  end
  
  def sender
    User.find_by(id: data&.dig('sender_id'))
  end
end

# app/notifications/message_notification.rb
class MessageNotification < Noticed::Base
  deliver_by :database
  deliver_by :action_cable, channel: "NotificationsChannel"
  
  param :message
  
  def message
    params[:message]
  end
  
  def url
    mensagens_admin_pages_path(recipient_id: params[:message].user_id)
  end
  
  def title
    "Nova mensagem"
  end
  
  def body
    "#{params[:message].user.name}: #{params[:message].content.truncate(30)}"
  end
end