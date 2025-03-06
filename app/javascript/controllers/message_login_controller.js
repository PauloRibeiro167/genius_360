import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-login"
export default class extends Controller {
  static targets = ["message"]

  connect() {
    setTimeout(() => {
      this.messageTarget.classList.add("opacity-0")
      setTimeout(() => {
        this.messageTarget.remove()
      }, 500)
    }, 5000)
  }
}
