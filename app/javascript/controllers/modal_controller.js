import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {

  document.addEventListener('DOMContentLoaded', function() {
    const modalToggles = document.querySelectorAll('[data-modal-toggle]');
    const modalHides = document.querySelectorAll('[data-modal-hide]');
    const body = document.body; 

    modalToggles.forEach(toggle => {
      toggle.addEventListener('click', () => {
        const target = toggle.getAttribute('data-modal-target');
        const modal = document.getElementById(target);
        if (modal) {
          modal.classList.remove('hidden');
          modal.setAttribute('aria-modal', 'true');
          modal.setAttribute('role', 'dialog');
          body.classList.add('modal-open');
          body.classList.add('blur-background'); 
          }
      });
    });

    modalHides.forEach(hide => {
      hide.addEventListener('click', () => {
        const target = hide.getAttribute('data-modal-hide');
        const modal = document.getElementById(target);
        if (modal) {
          modal.classList.add('hidden');
          modal.removeAttribute('aria-modal');
          modal.removeAttribute('role');
          body.classList.remove('modal-open');
          body.classList.remove('blur-background'); 
        }
      });
    });
  });
  }
}
