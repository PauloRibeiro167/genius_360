import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  connect() {
    this.sidebarTarget.addEventListener("mouseover", this.openSidebar.bind(this));
    this.sidebarTarget.addEventListener("mouseout", this.closeSidebar.bind(this));
    this.closeSidebar();
  }

  openSidebar() {
    this.sidebarTarget.classList.remove('w-20');
    this.sidebarTarget.classList.add('w-64');
    this.sidebarTarget.classList.add('group'); // Adiciona a classe group
  }

  closeSidebar() {
    this.sidebarTarget.classList.remove('w-64');
    this.sidebarTarget.classList.add('w-20');
    this.sidebarTarget.classList.remove('group'); // Remove a classe group
  }
}
