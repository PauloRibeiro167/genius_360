class Admin::NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.newest_first
  end
  
  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { head :no_content }
    end
  end
  
  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { head :no_content }
    end
  end

  def check
    unread_notifications = current_user.notifications.unread.count
    unread_messages = Message.where(recipient_id: current_user.id, read_at: nil).count

    render json: {
      unread_count: unread_notifications,
      unread_messages: unread_messages
    }
  end
end
