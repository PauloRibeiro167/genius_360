import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "title", "header"]

  connect() {
    if (!this.hasSidebarTarget) {
      console.warn("Sidebar target is missing");
      return;
    }
    this.element.addEventListener("mouseover", this.openSidebar.bind(this));
    this.element.addEventListener("mouseout", this.closeSidebar.bind(this));
  }

  disconnect() {
    this.element.removeEventListener("mouseover", this.openSidebar.bind(this));
    this.element.removeEventListener("mouseout", this.closeSidebar.bind(this));
  }

  openSidebar() {
    if (!this.hasSidebarTarget) return;
    
    this.sidebarTarget.classList.remove('w-20', 'sidebar-inactive');
    this.sidebarTarget.classList.add('w-64', 'group');
    
    if (this.hasTitleTarget) {
      this.titleTarget.classList.remove('translate-x-[-100%]');
      this.titleTarget.classList.add('translate-x-0');
    }
  }

  closeSidebar() {
    if (!this.hasSidebarTarget) return;
    
    this.sidebarTarget.classList.remove('w-64', 'group');
    this.sidebarTarget.classList.add('w-20', 'sidebar-inactive');
    
    if (this.hasTitleTarget) {
      this.titleTarget.classList.remove('translate-x-0');
      this.titleTarget.classList.add('translate-x-[-100%]');
    }
  }

  toggle() {
    if (!this.hasSidebarTarget) return;
    
    this.sidebarTarget.classList.toggle("w-20");
    this.sidebarTarget.classList.toggle("w-64");
    this.sidebarTarget.classList.toggle("sidebar-inactive");
    
    if (this.hasTitleTarget) {
      this.titleTarget.classList.toggle("hidden");
    }
  }
}
