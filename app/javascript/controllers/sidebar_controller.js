import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "title", "header"]

  connect() {
    console.log("Sidebar Controller connected");
    console.log("sidebarTarget:", this.sidebarTarget);
    this.element.addEventListener("mouseover", this.openSidebar.bind(this));
    this.element.addEventListener("mouseout", this.closeSidebar.bind(this));
  }

  disconnect() {
    console.log("Sidebar Controller disconnected")
  }

  openSidebar() {
    this.sidebarTarget.classList.remove('w-20');
    this.sidebarTarget.classList.add('w-64');
    this.sidebarTarget.classList.add('group'); // Adiciona a classe group
    this.sidebarTarget.classList.remove('sidebar-inactive'); // Remove a classe sidebar-inactive
    this.titleTarget.classList.remove('translate-x-[-100%]');
    this.titleTarget.classList.add('translate-x-0');
  }

  closeSidebar() {
    this.sidebarTarget.classList.remove('w-64');
    this.sidebarTarget.classList.add('w-20');
    this.sidebarTarget.classList.remove('group'); // Remove a classe group
    this.sidebarTarget.classList.add('sidebar-inactive'); // Adiciona a classe sidebar-inactive
    this.titleTarget.classList.remove('translate-x-0');
    this.titleTarget.classList.add('translate-x-[-100%]');
  }

  toggle() {
    this.sidebarTarget.classList.toggle("w-20")
    this.sidebarTarget.classList.toggle("w-64")
    this.sidebarTarget.classList.toggle("sidebar-inactive")
    if (this.hasTitleTarget) {
      this.titleTarget.classList.toggle("hidden")
    }
  }
}
