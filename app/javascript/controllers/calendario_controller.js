import { Controller } from "@hotwired/stimulus"
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import ptBrLocale from '@fullcalendar/core/locales/pt-br'
import { Modal } from 'flowbite'

export default class extends Controller {
  connect() {
    this.modal = new Modal(document.getElementById('evento-modal'))
    this.setupCalendar()
  }

  setupCalendar() {
    const avisos = JSON.parse(this.element.dataset.avisos || '[]')
    const reunioes = JSON.parse(this.element.dataset.reunioes || '[]')

    const calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin, timeGridPlugin],
      locale: ptBrLocale,
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      events: [
        ...avisos.map(aviso => ({
          title: `📢 ${aviso.titulo}`,
          start: aviso.created_at,
          description: aviso.descricao,
          backgroundColor: '#3B82F6', // blue-500
          borderColor: '#2563EB' // blue-600
        })),
        ...reunioes.map(reuniao => ({
          title: `📅 ${reuniao.titulo}`,
          start: reuniao.data,
          description: reuniao.descricao,
          backgroundColor: '#22C55E', // green-500
          borderColor: '#16A34A' // green-600
        }))
      ],
      eventClick: (info) => this.showEventModal(info.event)
    })

    calendar.render()
    this.calendar = calendar
  }

  showEventModal(event) {
    // Preencher dados no modal
    document.getElementById('evento-id').value = event.id
    document.getElementById('evento-tipo').value = event.extendedProps.tipo
    document.getElementById('evento-titulo-input').value = event.title.replace(/^[📢📅]\s/, '')
    document.getElementById('evento-data').value = event.start?.toISOString().slice(0, 16)
    document.getElementById('evento-descricao').value = event.extendedProps.description
    
    // Atualizar título do modal
    document.querySelector('.evento-titulo').textContent = 
      event.extendedProps.tipo === 'aviso' ? 'Editar Aviso' : 'Editar Reunião'

    this.modal.show()
  }

  async atualizarEvento(event) {
    event.preventDefault()
    const form = event.target
    const eventoId = form.querySelector('#evento-id').value
    const eventoTipo = form.querySelector('#evento-tipo').value
    
    try {
      const response = await fetch(`/admin/${eventoTipo}s/${eventoId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          titulo: form.querySelector('#evento-titulo-input').value,
          data: form.querySelector('#evento-data').value,
          descricao: form.querySelector('#evento-descricao').value
        })
      })

      if (response.ok) {
        this.modal.hide()
        // Recarregar eventos do calendário
        this.calendar.refetchEvents()
      }
    } catch (error) {
      console.error('Erro ao atualizar evento:', error)
    }
  }

  async excluirEvento(event) {
    event.preventDefault()
    
    const eventoId = document.getElementById('evento-id').value
    const eventoTipo = document.getElementById('evento-tipo').value

    if (confirm('Tem certeza que deseja excluir este evento?')) {
      try {
        const response = await fetch(`/admin/${eventoTipo}s/${eventoId}`, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
          }
        })

        if (response.ok) {
          this.modal.hide()
          this.calendar.refetchEvents()
        } else {
          alert('Erro ao excluir o evento. Por favor, tente novamente.')
        }
      } catch (error) {
        console.error('Erro ao excluir evento:', error)
        alert('Erro ao excluir o evento. Por favor, tente novamente.')
      }
    }
  }
}
