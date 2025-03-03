import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Desktop nav controller connected")
  }

  toggleMenu() {
    this.menuTarget.classList.toggle("hidden")
    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove("opacity-100")
      this.menuTarget.classList.add("opacity-0")
    } else {
      this.menuTarget.classList.remove("opacity-0")
      this.menuTarget.classList.add("opacity-100")
    }
  }
}
