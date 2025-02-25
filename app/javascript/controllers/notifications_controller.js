import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.checkNotifications()
    // Verificar a cada 30 segundos
    this.interval = setInterval(() => this.checkNotifications(), 30000)
  }

  disconnect() {
    if (this.interval) {
      clearInterval(this.interval)
    }
  }

  checkNotifications() {
    fetch('/admin/notifications/check')
      .then(response => response.json())
      .then(data => {
        const count = data.unread_count || 0
        const messageCount = data.unread_messages || 0
        
        // Atualizar contador de notificações gerais
        const badge = document.getElementById('notification-badge')
        if (badge) {
          badge.textContent = count
          badge.classList.toggle('hidden', count === 0)
        }

        // Atualizar contador de mensagens
        const messageBadge = document.getElementById('message-notification-badge')
        if (messageBadge) {
          messageBadge.textContent = messageCount
          messageBadge.classList.toggle('hidden', messageCount === 0)
        }
      })
  }
}
