import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  
  connect() {
    console.log("DropdownController conectado")
    // Fechar ao clicar fora
    document.addEventListener('click', this.clickOutside.bind(this))
  }
  
  disconnect() {
    console.log("DropdownController desconectado")
    document.removeEventListener('click', this.clickOutside.bind(this))
  }
  
  toggle(event) {
    event.stopPropagation()
    
    console.log("Dropdown toggle clicado")
    
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle('hidden')
      const isOpen = !this.contentTarget.classList.contains('hidden')
      console.log(`Dropdown ${isOpen ? "aberto" : "fechado"}`)
    } else {
      console.error("Dropdown content não encontrado")
    }
  }
  
  clickOutside(event) {
    // Se o dropdown estiver aberto e o clique for fora do dropdown
    if (this.hasContentTarget && !this.contentTarget.classList.contains('hidden')) {
      if (!this.element.contains(event.target)) {
        console.log("Clique fora do dropdown detectado, fechando dropdown")
        this.contentTarget.classList.add('hidden')
      }
    }
  }
}
