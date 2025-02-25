class MessageNotification < Noticed::Base
  deliver_by :database
  deliver_by :email, mailer: "NotificationsMailer"

  param :message

  def message
    params[:message]
  end

  def url
    message_path(params[:message])
  end
end
