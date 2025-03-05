import { Controller } from "@hotwired/stimulus"

// Gerencia a alternância entre modos de visualização (desktop/mobile)
export default class extends Controller {
  static targets = ["modeText", "modeIcon", "menuContainer", "mobileView", "desktopView"]
  
  connect() {
    // Removido console.log
    // Inicialmente em modo desktop
    this.isDesktopMode = true
    this.updateViewMode()
  }
  
  toggleViewMode() {
    this.isDesktopMode = !this.isDesktopMode
    this.updateViewMode()
  }
  
  updateViewMode() {
    if (this.isDesktopMode) {
      this.modeTextTarget.textContent = "Desktop"
      this.mobileViewTarget.classList.add("hidden")
      this.desktopViewTarget.classList.remove("hidden")
    } else {
      this.modeTextTarget.textContent = "Mobile"
      this.mobileViewTarget.classList.remove("hidden")
      this.desktopViewTarget.classList.add("hidden")
    }
  }
}
