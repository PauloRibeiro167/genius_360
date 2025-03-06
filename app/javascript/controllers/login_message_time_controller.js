import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login-message-time"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      if (this.element) {
        this.element.style.transition = 'opacity 0.5s ease'
        this.element.style.opacity = '0'
        setTimeout(() => {
          this.element.remove()
        }, 500)
      }
    }, 5000)
  }
}
