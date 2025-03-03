import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    sales: Array,
    leads: Array,
    months: Array
  }

  connect() {
    this.initializeCanvas()
    this.drawChart()
    
    // Adicionar listener para redimensionamento
    window.addEventListener('resize', () => {
      this.initializeCanvas()
      this.drawChart()
    })
  }

  initializeCanvas() {
    const canvas = this.element.querySelector('canvas')
    const container = this.element
    canvas.width = container.offsetWidth
    canvas.height = 250 // altura fixa
  }

  drawChart() {
    const canvas = this.element.querySelector('canvas')
    const ctx = canvas.getContext('2d')
    
    // Adicione no início do método drawChart:
    ctx.font = '12px system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'

    // Limpar canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    
    const padding = 40
    const width = canvas.width - (padding * 2)
    const height = canvas.height - (padding * 2)
    
    const salesData = this.salesValue
    const leadsData = this.leadsValue
    const months = this.monthsValue
    
    // Calcular escala Y
    const maxValue = Math.max(
      Math.max(...salesData),
      Math.max(...leadsData)
    )
    const yScale = height / maxValue
    const xStep = width / (months.length - 1)
    
    // Background
    ctx.fillStyle = '#581c87' // bg-purple-900
    ctx.fillRect(0, 0, canvas.width, canvas.height)
    
    // Grid
    this.drawGrid(ctx, padding, width, height, 5)
    
    // Eixos
    this.drawAxes(ctx, padding, width, height)
    
    // Labels
    this.drawLabels(ctx, months, padding, width, height)
    
    // Dados
    this.drawData(ctx, salesData, '#ec4899', padding, height, xStep, yScale)
    this.drawData(ctx, leadsData, '#9333ea', padding, height, xStep, yScale)
    
    // Legenda
    this.drawLegend(ctx, padding, canvas.width)
  }

  drawGrid(ctx, padding, width, height, divisions) {
    ctx.beginPath()
    ctx.strokeStyle = 'rgba(255,255,255,0.1)'
    ctx.lineWidth = 1
    
    const stepY = height / divisions
    const stepX = width / divisions
    
    // Linhas horizontais
    for (let y = 0; y <= divisions; y++) {
      const yPos = padding + (y * stepY)
      ctx.moveTo(padding, yPos)
      ctx.lineTo(padding + width, yPos)
    }
    
    // Linhas verticais
    for (let x = 0; x <= divisions; x++) {
      const xPos = padding + (x * stepX)
      ctx.moveTo(xPos, padding)
      ctx.lineTo(xPos, padding + height)
    }
    
    ctx.stroke()
  }

  drawAxes(ctx, padding, width, height) {
    ctx.beginPath()
    ctx.strokeStyle = 'rgba(255,255,255,0.5)'
    ctx.lineWidth = 2
    
    // Eixo Y
    ctx.moveTo(padding, padding)
    ctx.lineTo(padding, height + padding)
    
    // Eixo X
    ctx.moveTo(padding, height + padding)
    ctx.lineTo(width + padding, height + padding)
    
    ctx.stroke()
  }

  drawLabels(ctx, months, padding, width, height) {
    ctx.fillStyle = '#ffffff'
    ctx.textAlign = 'center'
    
    const step = width / (months.length - 1)
    
    months.forEach((month, i) => {
      const x = padding + (i * step)
      ctx.fillText(month, x, height + padding + 20)
    })
  }

  drawData(ctx, data, color, padding, height, xStep, yScale) {
    ctx.beginPath()
    ctx.strokeStyle = color
    ctx.lineWidth = 2
    
    data.forEach((value, i) => {
      const x = padding + (i * xStep)
      const y = height + padding - (value * yScale)
      
      if (i === 0) {
        ctx.moveTo(x, y)
      } else {
        ctx.lineTo(x, y)
      }
      
      // Pontos
      ctx.fillStyle = color
      ctx.beginPath()
      ctx.arc(x, y, 3, 0, Math.PI * 2)
      ctx.fill()
    })
    
    ctx.stroke()
  }

  drawLegend(ctx, padding, width) {
    const legendY = padding / 2
    const textPadding = 25
    
    // Vendas
    ctx.fillStyle = '#ec4899'
    ctx.beginPath()
    ctx.arc(padding, legendY, 4, 0, Math.PI * 2)
    ctx.fill()
    
    ctx.fillStyle = '#ffffff'
    ctx.textAlign = 'left'
    ctx.fillText('Vendas', padding + 10, legendY + 4)
    
    // Leads
    const leadsX = padding + textPadding + ctx.measureText('Vendas').width + 20
    
    ctx.fillStyle = '#9333ea'
    ctx.beginPath()
    ctx.arc(leadsX, legendY, 4, 0, Math.PI * 2)
    ctx.fill()
    
    ctx.fillStyle = '#ffffff'
    ctx.fillText('Leads', leadsX + 10, legendY + 4)
  }
}
