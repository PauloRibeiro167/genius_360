import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chart"]
  static values = { 
    data: Object,
    options: Object
  }

  connect() {
    this.initializeChart()
  }
  
  initializeChart() {
    // Verifica se o Chartkick está disponível
    if (typeof Chartkick === 'undefined') {
      console.error('Chartkick não está definido. Aguardando carregamento...')
      setTimeout(() => this.initializeChart(), 100)
      return
    }
    
    // Agora renderiza o gráfico se os dados estiverem disponíveis
    if (this.hasDataValue) {
      this.renderChart()
    }
  }

  renderChart() {
    new Chartkick.BarChart(this.chartTarget, this.dataValue, this.optionsValue)
  }
}
