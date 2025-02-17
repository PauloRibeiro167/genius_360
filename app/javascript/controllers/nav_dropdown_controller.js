import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "dropdown"]

  initialize() {
    this.boundClickHandler = this.handleClickOutside.bind(this)
  }

  connect() {
    document.addEventListener('click', this.boundClickHandler)
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickHandler)
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeAll()
    }
  }

  toggleMobileMenu(event) {
    event.preventDefault()
    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle('hidden')
    }
  }

  toggleDropdown(event) {
    event.preventDefault()
    if (this.hasDropdownTarget) {
      this.dropdownTarget.classList.toggle('hidden')
    }
  }

  closeAll() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add('hidden')
    }
    if (this.hasDropdownTarget) {
      this.dropdownTarget.classList.add('hidden')
    }
  }
}
