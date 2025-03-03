class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Verificando se current_user existe antes de tentar usá-lo
    if defined?(current_user) && current_user.present?
      stream_from "chat_#{current_user.id}"
    else
      # Fallback para usuários não autenticados
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
