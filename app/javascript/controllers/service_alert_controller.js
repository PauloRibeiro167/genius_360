import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    title: String,
    text: String
  }

  initialize() {
    this.handleMouseEnter = this.handleMouseEnter.bind(this)
    this.handleMouseLeave = this.handleMouseLeave.bind(this)
  }

  connect() {
    this.showAlert = this.showAlert.bind(this);
    this.element.addEventListener('click', this.showAlert);
    this.element.addEventListener('mouseenter', this.handleMouseEnter)
    this.element.addEventListener('mouseleave', this.handleMouseLeave)
  }

  disconnect() {
    this.element.removeEventListener('click', this.showAlert);
    this.element.removeEventListener('mouseenter', this.handleMouseEnter)
    this.element.removeEventListener('mouseleave', this.handleMouseLeave)
  }

  handleMouseEnter() {
    this.element.classList.add('scale-105', 'shadow-xl')
  }

  handleMouseLeave() {
    this.element.classList.remove('scale-105', 'shadow-xl')
  }

  showAlert(event) {
    if (document.querySelector('.alert-box')) return

    const alertBox = document.createElement('div')
    alertBox.className = 'alert-box fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 z-10 bg-gray-900/80 rounded-lg backdrop-blur-sm shadow-2xl shadow-purple-500/50 w-60 text-white p-6 text-center opacity-0 transition-opacity duration-300'
    
    alertBox.innerHTML = `
      <h2 class="text-2xl font-semibold mb-4">${this.titleValue}</h2>
      <p class="mb-6">${this.textValue}</p>
      <button class="absolute top-2 right-2 text-white">&times;</button>
      <button class="px-4 py-2 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 transition-colors duration-300">OK</button>
    `

    document.body.appendChild(alertBox)
    
    // Configurar eventos dos botões
    alertBox.querySelector('button:last-child').addEventListener('click', () => this.closeAlert(alertBox))
    alertBox.querySelector('button:first-child').addEventListener('click', () => this.closeAlert(alertBox))

    requestAnimationFrame(() => alertBox.classList.remove('opacity-0'))
  }

  closeAlert(alertBox) {
    alertBox.classList.add('opacity-0')
    setTimeout(() => alertBox.remove(), 300)
  }
}
