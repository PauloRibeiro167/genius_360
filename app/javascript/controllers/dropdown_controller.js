import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdownContent"]
  
  connect() {
    try {
      document.addEventListener('click', this.clickOutside.bind(this))
    } catch (error) {
      console.error('Erro ao conectar dropdown:', error)
    }
  }
  
  disconnect() {
    try {
      document.removeEventListener('click', this.clickOutside.bind(this))
    } catch (error) {
      console.error('Erro ao desconectar dropdown:', error)
    }
  }
  
  toggle(event) {
    try {
      event?.stopPropagation()
      
      if (!this.hasDropdownContentTarget) {
        throw new Error('Target dropdownContent não encontrado')
      }

      const isOpen = this.dropdownContentTarget.classList.toggle('hidden')
      isOpen && this.positionDropdown()
      
    } catch (error) {
      console.error('Erro ao alternar dropdown:', {
        erro: error.message,
        elemento: this.element,
        target: this.dropdownContentTarget
      })
    }
  }
  
  positionDropdown() {
    try {
      window.innerWidth < 768 && this.dropdownContentTarget.classList.add('w-full')
    } catch (error) {
      console.error('Erro ao posicionar dropdown:', error)
    }
  }
  
  clickOutside(event) {
    try {
      const shouldClose = this.hasDropdownContentTarget && 
                         !this.dropdownContentTarget.classList.contains('hidden') && 
                         !this.element.contains(event.target)
      
      shouldClose && this.dropdownContentTarget.classList.add('hidden')
    } catch (error) {
      console.error('Erro ao processar clique externo:', error)
    }
  }
}
