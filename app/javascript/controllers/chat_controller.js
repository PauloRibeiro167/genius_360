import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["messages", "form"]

  connect() {
    this.userId = this.element.dataset.userId
    this.subscribeToChannel()
    this.scrollToBottom()
  }

  subscribeToChannel() {
    this.subscription = consumer.subscriptions.create("ChatChannel", {
      received: this.received.bind(this)
    })
  }

  received(data) {
    const messageHtml = this.buildMessageHtml(data)
    this.messagesTarget.insertAdjacentHTML('beforeend', messageHtml)
    this.scrollToBottom()
  }

  buildMessageHtml(data) {
    const isCurrentUser = data.sender_id == this.userId
    return `
      <div class="flex ${isCurrentUser ? 'justify-end' : 'justify-start'}">
        <div class="${isCurrentUser ? 'bg-blue-600' : 'bg-gray-700'} rounded-lg px-4 py-2 max-w-[70%]">
          <div class="text-xs text-gray-300 mb-1">
            ${data.sender_name} • ${data.created_at}
          </div>
          <p class="text-sm text-gray-200">${data.content}</p>
        </div>
      </div>
    `
  }

  submit(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)

    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      credentials: 'same-origin'
    })

    form.reset()
    return false
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
