import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  connect() {
    this.showAlert = this.showAlert.bind(this);
    this.element.addEventListener('click', this.showAlert);
  }

  disconnect() {
    this.element.removeEventListener('click', this.showAlert);
  }

  showAlert(event) {
    // Verifica se já existe um alerta na tela
    if (document.querySelector('.alert-box')) {
      return;
    }

    const button = event.currentTarget;
    const title = button.getAttribute('data-alert-title') || 'Em breve';
    const text = button.getAttribute('data-alert-text') || 'Esta funcionalidade estará disponível em breve.';
    
    const alertBox = document.createElement('div');
    alertBox.className = 'alert-box fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 z-10 bg-gray-900/80 rounded-lg backdrop-blur-sm shadow-2xl shadow-purple-500/50 w-60 text-white p-6 text-center opacity-0 transition-opacity duration-300  hover:border-gradient-to-r hover:from-purple-500 hover:to-pink-500 hover:backdrop-blur-sm hover:scale-105 animate-pulse';

    const alertTitle = document.createElement('h2');
    alertTitle.className = 'text-2xl font-semibold mb-4';
    alertTitle.innerText = title;
    alertBox.appendChild(alertTitle);

    const alertText = document.createElement('p');
    alertText.className = 'mb-6';
    alertText.innerText = text;
    alertBox.appendChild(alertText);

    const closeButton = document.createElement('button');
    closeButton.className = 'absolute top-2 right-2 text-white';
    closeButton.innerHTML = '&times;';
    closeButton.addEventListener('click', () => {
      alertBox.classList.add('opacity-0');
      setTimeout(() => {
        document.body.removeChild(alertBox);
      }, 300);
    });
    alertBox.appendChild(closeButton);

    const alertButton = document.createElement('button');
    alertButton.className = 'px-4 py-2 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 transition-colors duration-300';
    alertButton.innerText = 'OK';
    alertButton.addEventListener('click', () => {
      alertBox.classList.add('opacity-0');
      alertButton.disabled = true; 
      setTimeout(() => {
        document.body.removeChild(alertBox);
      }, 300); 
    });
    alertBox.appendChild(alertButton);

    document.body.appendChild(alertBox);

    // Adiciona a classe para a transição de opacidade
    requestAnimationFrame(() => {
      alertBox.classList.remove('opacity-0');
    });
  }
}
