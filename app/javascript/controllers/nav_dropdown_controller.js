import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "userDropdown"]

  connect() {
    // Fechar os dropdowns quando clicar fora deles
    document.addEventListener('click', this.closeDropdownsOnClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeDropdownsOnClickOutside.bind(this))
  }

  toggleMobileMenu(event) {
    event.stopPropagation()
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle('hidden')
    }
  }

  toggleUserDropdown(event) {
    event.stopPropagation()
    if (this.hasUserDropdownTarget) {
      this.userDropdownTarget.classList.toggle('hidden')
    }
  }

  closeDropdownsOnClickOutside(event) {
    // Não fechar se o clique foi dentro de elementos do controlador
    if (this.element.contains(event.target)) {
      const isToggleButton = 
        event.target.hasAttribute('data-action') && 
        (event.target.getAttribute('data-action').includes('toggleMobileMenu') || 
         event.target.getAttribute('data-action').includes('toggleUserDropdown'))
      
      // Se clicou em um botão de toggle, não fazemos nada
      if (isToggleButton) return
    } else {
      // Fechar os dropdowns se o clique foi fora
      if (this.hasUserDropdownTarget) {
        this.userDropdownTarget.classList.add('hidden')
      }
      
      if (this.hasMobileMenuTarget) {
        this.mobileMenuTarget.classList.add('hidden')
      }
    }
  }
}
