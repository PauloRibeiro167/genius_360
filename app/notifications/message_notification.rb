class MessageNotification < Noticed::Base
  deliver_by :database

  param :message

  def message
    params[:message]
  end

  def url
    mensagens_admin_pages_path(recipient_id: params[:message].user_id)
  end
end
