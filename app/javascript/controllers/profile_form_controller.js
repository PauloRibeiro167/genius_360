import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "editButton", "field", "display"]

  connect() {
    this.toggleEditMode(false)
  }

  toggleEdit(event) {
    event.preventDefault()
    const isEditing = this.formTarget.classList.contains("editing")
    this.toggleEditMode(!isEditing)
  }

  toggleEditMode(editing) {
    this.formTarget.classList.toggle("editing", editing)
    this.fieldTargets.forEach(field => field.disabled = !editing)
    this.displayTargets.forEach(display => display.classList.toggle("hidden", editing))
    this.editButtonTarget.textContent = editing ? "Cancelar Edição" : "Editar Perfil"
  }
}
