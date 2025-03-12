import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "desktopMenu", "mobileMenuButton"]
  
  connect() {
    this.checkScreenSize()
    window.addEventListener('resize', this.checkScreenSize.bind(this))
    
    // Em vez de atribuir à propriedade hasDesktopMenuTarget, 
    // vamos armazenar o estado em uma nova propriedade
    this._hasDesktopMenu = this.element.querySelector('[data-mobile-nav-target="desktopMenu"]') !== null
  }
  
  disconnect() {
    window.removeEventListener('resize', this.checkScreenSize.bind(this))
  }
  
  toggleMenu() {
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle('hidden')
    }
    
    if (this.hasMobileMenuButtonTarget) {
      const expanded = this.mobileMenuButtonTarget.getAttribute('aria-expanded') === 'true' || false
      this.mobileMenuButtonTarget.setAttribute('aria-expanded', !expanded)
    }
  }
  
  closeMobileMenu() {
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.add('hidden')
    }
    
    if (this.hasMobileMenuButtonTarget) {
      this.mobileMenuButtonTarget.setAttribute('aria-expanded', 'false')
    }
  }
  
  checkScreenSize() {
    const isMobile = window.innerWidth < 768
    
    if (this.hasMobileMenuTarget) {
      if (isMobile) {
        this.mobileMenuTarget.classList.add('hidden')
      } else {
        this.mobileMenuTarget.classList.remove('hidden')
      }
    }
    
    // Usar a nova propriedade _hasDesktopMenu
    if (this._hasDesktopMenu && this.hasDesktopMenuTarget) {
      this.desktopMenuTarget.classList.toggle('hidden', isMobile)
    }
  }
}
