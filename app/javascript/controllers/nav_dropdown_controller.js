import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "userDropdown"]

  initialize() {
    this.boundClickHandler = this.handleClickOutside.bind(this)
  }

  connect() {
    console.log("Nav dropdown controller connected")
    console.log("Dropdown element:", this.userDropdownTarget)
    document.addEventListener('click', this.boundClickHandler)
  }

  disconnect() {
    console.log("Nav dropdown controller disconnected")
    document.removeEventListener('click', this.boundClickHandler)
  }

  handleClickOutside(event) {
    console.log("Close dropdown called")
    console.log("Click target:", event.target)
    console.log("Is click inside dropdown:", this.element.contains(event.target))
    
    const isDropdownButton = event.target.closest('[data-dropdown-toggle]')
    if (!isDropdownButton && !this.element.contains(event.target)) {
      this.closeAll()
      console.log("Dropdown closed")
    }
  }

  toggleMobileMenu() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle('hidden')
    }
  }

  toggleUserDropdown(event) {
    console.log("Toggle dropdown called")
    console.log("Current dropdown state:", this.userDropdownTarget.classList.contains('hidden'))
    event.preventDefault()
    if (this.hasUserDropdownTarget) {
      this.userDropdownTarget.classList.toggle('hidden')
      console.log("New dropdown state:", this.userDropdownTarget.classList.contains('hidden'))
      // Fecha o menu mobile se estiver aberto
      if (this.hasMenuTarget && !this.menuTarget.classList.contains('hidden')) {
        this.menuTarget.classList.add('hidden')
      }
    }
  }

  closeAll() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add('hidden')
    }
    if (this.hasUserDropdownTarget) {
      this.userDropdownTarget.classList.add('hidden')
    }
  }
}
