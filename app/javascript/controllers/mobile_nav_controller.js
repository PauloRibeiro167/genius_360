import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    console.log("MobileNavController conectado")
    this.applyResponsiveLayout()
    window.addEventListener("resize", this.applyResponsiveLayout.bind(this))
  }
  
  disconnect() {
    console.log("MobileNavController desconectado")
    window.removeEventListener("resize", this.applyResponsiveLayout.bind(this))
  }
  
  toggleMenu(event) {
    console.log("Botão de menu mobile clicado")
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    const expanded = this.menuTarget.classList.contains("hidden") ? "false" : "true"
    this.element.querySelector("[aria-expanded]").setAttribute("aria-expanded", expanded)
    console.log(`Menu mobile ${expanded === "true" ? "aberto" : "fechado"}`)
  }
  
  applyResponsiveLayout() {
    const isMobile = window.innerWidth < 768 // breakpoint md do Tailwind
    console.log(`Verificando tamanho da tela: ${window.innerWidth}px, isMobile: ${isMobile}`)
    
    const mobileButton = document.getElementById('mobile-menu-button')
    const desktopMenu = document.getElementById('desktop-menu')
    
    if (mobileButton && desktopMenu) {
      if (isMobile) {
        console.log("Aplicando layout mobile")
        mobileButton.style.display = "inline-flex"
        desktopMenu.style.display = "none"
      } else {
        console.log("Aplicando layout desktop")
        mobileButton.style.display = "none"
        desktopMenu.style.display = "flex"
        
        // Se estiver em desktop, garantir que o menu mobile esteja fechado
        if (this.hasMenuTarget && !this.menuTarget.classList.contains("hidden")) {
          console.log("Fechando menu mobile ao redimensionar para desktop")
          this.menuTarget.classList.add("hidden")
        }
      }
    } else {
      console.error("Elementos necessários não encontrados")
    }
  }
}
