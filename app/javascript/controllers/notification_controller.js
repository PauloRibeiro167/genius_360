import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "badge"]
  
  connect() {
    document.addEventListener('click', this.closeIfClickedOutside)
  }
  
  disconnect() {
    document.removeEventListener('click', this.closeIfClickedOutside)
  }
  
  toggle() {
    this.menuTarget.classList.toggle('hidden')
  }
  
  closeIfClickedOutside = (event) => {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains('hidden')) {
      this.menuTarget.classList.add('hidden')
    }
  }
  
  markAsRead() {
    if (this.hasBadgeTarget) {
      this.badgeTarget.classList.add('hidden')
    }
  }
}
