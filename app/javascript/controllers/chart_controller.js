import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    sales: Array,
    leads: Array,
    months: Array,
    responsive: { type: Boolean, default: true },
    maintainAspectRatio: { type: Boolean, default: false }
  }
  
  connect() {
    this.initializeChart()
    
    // Adicionar listener para redimensionamento da janela
    window.addEventListener('resize', this.resizeChart.bind(this))
  }
  
  disconnect() {
    // Limpar o listener quando o controlador é desconectado
    window.removeEventListener('resize', this.resizeChart.bind(this))
  }
  
  resizeChart() {
    // Redimensionar o gráfico se necessário
    this.initializeChart()
  }
  
  initializeChart() {
    const canvas = this.element.querySelector('canvas')
    if (!canvas) return
    
    const ctx = canvas.getContext('2d')
    const width = canvas.width
    const height = canvas.height
    
    // Limpar o canvas
    ctx.clearRect(0, 0, width, height)
    
    const salesColor = getComputedStyle(document.documentElement).getPropertyValue('--chart-color-1') || '#007BFF'
    const leadsColor = getComputedStyle(document.documentElement).getPropertyValue('--chart-color-2') || '#28A745'
    
    const sales = this.salesValue
    const leads = this.leadsValue
    const months = this.monthsValue
    
    // Encontrar os valores máximos para escalar o gráfico
    const maxSales = Math.max(...sales)
    const maxLeads = Math.max(...leads)
    const maxValue = Math.max(maxSales, maxLeads)
    const paddingValue = maxValue * 0.1 // 10% de padding
    const chartMax = maxValue + paddingValue
    
    // Definir margens
    const margin = {
      top: 20,
      right: 20,
      bottom: 40,
      left: 50
    }
    
    const innerWidth = width - margin.left - margin.right
    const innerHeight = height - margin.top - margin.bottom
    
    // Desenhar eixos
    ctx.beginPath()
    ctx.strokeStyle = '#ddd'
    ctx.lineWidth = 1
    
    // Eixo Y
    ctx.moveTo(margin.left, margin.top)
    ctx.lineTo(margin.left, height - margin.bottom)
    ctx.stroke()
    
    // Eixo X
    ctx.moveTo(margin.left, height - margin.bottom)
    ctx.lineTo(width - margin.right, height - margin.bottom)
    ctx.stroke()
    
    // Desenhar linhas de grade horizontais
    const gridLines = 5
    ctx.beginPath()
    ctx.strokeStyle = getComputedStyle(document.documentElement).getPropertyValue('--chart-grid-color') || '#eee'
    ctx.lineWidth = 0.5
    
    for (let i = 0; i <= gridLines; i++) {
      const y = margin.top + (innerHeight / gridLines * i)
      ctx.moveTo(margin.left, y)
      ctx.lineTo(width - margin.right, y)
      
      // Adicionar valores no eixo Y
      const value = Math.round((chartMax - (chartMax / gridLines * i)))
      ctx.fillStyle = getComputedStyle(document.documentElement).getPropertyValue('--chart-font-color') || '#666'
      ctx.textAlign = 'right'
      ctx.fillText(value, margin.left - 5, y + 5)
    }
    ctx.stroke()
    
    // Desenhar rótulos do eixo X (meses)
    const xStep = innerWidth / (months.length - 1)
    
    ctx.fillStyle = getComputedStyle(document.documentElement).getPropertyValue('--chart-font-color') || '#666'
    ctx.textAlign = 'center'
    months.forEach((month, i) => {
      const x = margin.left + xStep * i
      ctx.fillText(month, x, height - margin.bottom + 20)
    })
    
    // Função para converter valores de dados para coordenadas no canvas
    const getX = (index) => margin.left + (innerWidth / (months.length - 1)) * index
    const getY = (value) => margin.top + innerHeight - (value / chartMax * innerHeight)
    
    // Desenhar linha de vendas
    this.drawLine(ctx, sales, getX, getY, salesColor, 0.2)
    
    // Desenhar linha de leads
    this.drawLine(ctx, leads, getX, getY, leadsColor, 0.2)
    
    // Adicionar legenda
    this.createLegend(salesColor, leadsColor)
  }
  
  drawLine(ctx, data, getX, getY, color, alphaFill = 0.2) {
    // Desenhar área preenchida
    ctx.beginPath()
    ctx.moveTo(getX(0), getY(0))
    
    data.forEach((value, i) => {
      ctx.lineTo(getX(i), getY(value))
    })
    
    // Completar o caminho para preencher a área
    ctx.lineTo(getX(data.length - 1), getY(0))
    ctx.lineTo(getX(0), getY(0))
    
    ctx.fillStyle = this.hexToRgba(color, alphaFill)
    ctx.fill()
    
    // Desenhar linha
    ctx.beginPath()
    ctx.moveTo(getX(0), getY(data[0]))
    
    data.forEach((value, i) => {
      if (i > 0) ctx.lineTo(getX(i), getY(value))
    })
    
    ctx.strokeStyle = color
    ctx.lineWidth = 2
    ctx.stroke()
    
    // Desenhar pontos
    data.forEach((value, i) => {
      ctx.beginPath()
      ctx.arc(getX(i), getY(value), 4, 0, Math.PI * 2)
      ctx.fillStyle = 'white'
      ctx.fill()
      ctx.strokeStyle = color
      ctx.lineWidth = 2
      ctx.stroke()
    })
  }
  
  createLegend(salesColor, leadsColor) {
    // Criar ou atualizar legenda HTML
    let legend = this.element.querySelector('.chart-legend')
    
    if (!legend) {
      legend = document.createElement('div')
      legend.className = 'chart-legend'
      legend.style.display = 'flex'
      legend.style.justifyContent = 'center'
      legend.style.gap = '20px'
      legend.style.marginTop = '10px'
      this.element.appendChild(legend)
    } else {
      legend.innerHTML = ''
    }
    
    // Item de legenda para vendas
    const salesItem = document.createElement('div')
    salesItem.style.display = 'flex'
    salesItem.style.alignItems = 'center'
    salesItem.style.gap = '5px'
    
    const salesMarker = document.createElement('div')
    salesMarker.style.width = '12px'
    salesMarker.style.height = '12px'
    salesMarker.style.backgroundColor = salesColor
    salesMarker.style.borderRadius = '50%'
    
    const salesText = document.createElement('span')
    salesText.textContent = 'Vendas'
    
    salesItem.appendChild(salesMarker)
    salesItem.appendChild(salesText)
    legend.appendChild(salesItem)
    
    // Item de legenda para leads
    const leadsItem = document.createElement('div')
    leadsItem.style.display = 'flex'
    leadsItem.style.alignItems = 'center'
    leadsItem.style.gap = '5px'
    
    const leadsMarker = document.createElement('div')
    leadsMarker.style.width = '12px'
    leadsMarker.style.height = '12px'
    leadsMarker.style.backgroundColor = leadsColor
    leadsMarker.style.borderRadius = '50%'
    
    const leadsText = document.createElement('span')
    leadsText.textContent = 'Leads'
    
    leadsItem.appendChild(leadsMarker)
    leadsItem.appendChild(leadsText)
    legend.appendChild(leadsItem)
  }
  
  // Utilitário para converter cores hex/rgb para rgba com transparência
  hexToRgba(hex, alpha = 1) {
    if (hex.startsWith('rgb')) {
      return hex.replace(')', `, ${alpha})`).replace('rgb', 'rgba');
    }
    
    let r = 0, g = 0, b = 0;
    if (hex.length === 4) {
      r = parseInt(hex[1] + hex[1], 16);
      g = parseInt(hex[2] + hex[2], 16);
      b = parseInt(hex[3] + hex[3], 16);
    } else if (hex.length === 7) {
      r = parseInt(hex.slice(1, 3), 16);
      g = parseInt(hex.slice(3, 5), 16);
      b = parseInt(hex.slice(5, 7), 16);
    }
    
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
  }
}
