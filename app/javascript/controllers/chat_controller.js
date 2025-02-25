import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["messages", "form"]
  
  connect() {
    this.scrollToBottom()
    this.setupSubscription()
  }

  scrollToBottom() {
    const messages = this.messagesTarget
    messages.scrollTop = messages.scrollHeight
  }

  setupSubscription() {
    const userId = this.element.dataset.userId
    
    this.subscription = createConsumer().subscriptions.create(
      { channel: "ChatChannel", user_id: userId },
      {
        received: (data) => {
          this.messagesTarget.insertAdjacentHTML('beforeend', data)
          this.scrollToBottom()
        }
      }
    )
  }

  submit(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)

    fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      },
      credentials: 'same-origin'
    }).then(() => {
      form.reset()
      this.scrollToBottom()
    })
  }
}
