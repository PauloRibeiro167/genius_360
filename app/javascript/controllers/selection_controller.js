import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "option"]

  connect() {
    // Botões iniciam sem seleção
    this.buttonTargets.forEach(button => {
      button.classList.remove("bg-purple-700", "border-purple-400")
      button.classList.add("bg-purple-800", "border-purple-600")
    })
    
    // Todas as opções iniciam escondidas
    this.optionTargets.forEach(option => {
      option.classList.add("hidden")
    })
  }

  selectOption(event) {
    // Remove seleção de todos os botões
    this.buttonTargets.forEach(button => {
      button.classList.remove("bg-purple-700", "border-purple-400")
      button.classList.add("bg-purple-800", "border-purple-600")
    })
    
    // Adiciona seleção ao botão clicado
    const button = event.currentTarget
    button.classList.remove("bg-purple-800", "border-purple-600")
    button.classList.add("bg-purple-700", "border-purple-400")
    
    // Esconde todas as opções
    this.optionTargets.forEach(option => {
      option.classList.add("hidden")
    })
    
    // Mostra a opção selecionada
    const selectedOption = button.dataset.option
    this.optionTargets.forEach(option => {
      if (option.dataset.optionName === selectedOption) {
        option.classList.remove("hidden")
      }
    })
  }
}
