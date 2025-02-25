class MessageNotification < Noticed::Base
  deliver_by :database
  deliver_by :action_cable, channel: "NotificationsChannel"
  
  param :message
  
  def message
    params[:message]
  end
  
  def url
    Rails.application.routes.url_helpers.mensagens_admin_pages_path(recipient_id: params[:message].user_id)
  end
  
  def title
    "Nova mensagem"
  end
  
  def body
    "#{params[:message].user.name}: #{params[:message].content.truncate(30)}"
  end
end
