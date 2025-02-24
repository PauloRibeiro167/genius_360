// app/javascript/controllers/login_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["error"]

  connect() {
    this.element.addEventListener("ajax:success", this.handleSuccess.bind(this))
    this.element.addEventListener("ajax:error", this.handleError.bind(this))
  }

  handleSuccess(event) {
    window.location.href = "/"
  }

  handleError(event) {
    const [data] = event.detail
    this.errorTarget.textContent = data.error || "Credenciais inválidas"
    this.errorTarget.classList.remove("hidden")
  }
}