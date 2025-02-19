// app/javascript/controllers/login_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["error"]

  static values = {
    formSelector: { type: String, default: "[data-login-form]" },
    submitButtonSelector: { type: String, default: "[data-login-submit]" }
  }

  connect() {
    this.element.addEventListener("submit", this.handleSubmit.bind(this))
  }

  async handleSubmit(event) {
    event.preventDefault()
    const form = event.target.closest(this.formSelector)
    const formData = new FormData(form)

    try {
      const response = await fetch(form.action, {
        method: "POST",
        body: formData
      })

      if (!response.ok) {
        throw new Error(await response.text())
      }

      const data = await response.json()
      if (data.success) {
        // Lidar com o sucesso (por exemplo, atualizar o estado do aplicativo)
        console.log("Login bem-sucedido!")
      } else {
        this.setError(data.error)
      }
    } catch (error) {
      console.error("Erro durante o login:", error)
      this.setError(error.message)
    }
  }

  setError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("hidden")
  }

  hideError() {
    this.errorTarget.textContent = ""
    this.errorTarget.classList.add("hidden")
  }
}