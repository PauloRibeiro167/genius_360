import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    if (this.hasCanvasTarget) {
      this.buildChart()
    } else {
      console.warn("Canvas target não encontrado para o chart controller")
    }
  }

  buildChart() {
    const ctx = this.canvasTarget.getContext('2d')
    
    new window.Chart(ctx, {
      type: this.element.dataset.chartType || 'line',
      data: {
        labels: JSON.parse(this.element.dataset.labels || '[]'),
        datasets: JSON.parse(this.element.dataset.datasets || '[]')
      },
      options: JSON.parse(this.element.dataset.options || '{}')
    })
  }
}
