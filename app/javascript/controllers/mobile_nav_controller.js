import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "desktopMenu"]

  connect() {
    // Configuração inicial baseada no tamanho da tela
    this.checkScreenSize()
    // Adicionar listener com debounce para resize
    this.resizeTimer = null
    window.addEventListener('resize', () => {
      clearTimeout(this.resizeTimer)
      this.resizeTimer = setTimeout(() => this.checkScreenSize(), 250)
    })
  }

  disconnect() {
    window.removeEventListener('resize', this.checkScreenSize.bind(this))
    clearTimeout(this.resizeTimer)
  }

  toggleMenu(event) {
    event.preventDefault()
    const mobileMenu = this.mobileMenuTarget
    mobileMenu.classList.toggle('hidden')
  }

  checkScreenSize() {
    const isMobile = window.innerWidth < 768 // breakpoint md do Tailwind
    
    // Menu Desktop
    if (isMobile) {
      this.desktopMenuTarget.classList.add('hidden')
      this.desktopMenuTarget.classList.remove('md:flex')
    } else {
      this.desktopMenuTarget.classList.remove('hidden')
      this.desktopMenuTarget.classList.add('md:flex')
      // Sempre esconde o menu mobile em desktop
      this.mobileMenuTarget.classList.add('hidden')
    }
  }
}
