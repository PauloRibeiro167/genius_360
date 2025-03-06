import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  confirmAlert(event) {
    event.preventDefault()
    
    Swal.fire({
      title: event.currentTarget.dataset.sweetAlertConfirm,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sim',
      cancelButtonText: 'Cancelar'
    }).then((result) => {
      if (result.isConfirmed) {
        const url = event.currentTarget.dataset.sweetAlertUrl
        const method = event.currentTarget.dataset.sweetAlertMethod
        const token = document.querySelector('meta[name="csrf-token"]').content

        fetch(url, {
          method: method.toUpperCase(),
          headers: {
            'X-CSRF-Token': token,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          credentials: 'same-origin'
        }).then(response => {
          if (response.ok) {
            window.location.reload()
          }
        })
      }
    })
  }
}
