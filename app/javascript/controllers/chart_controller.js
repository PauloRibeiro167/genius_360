import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'
import { registerables } from 'chart.js'

// Registrar componentes necessários para evitar carregamento automático de fontes
Chart.register(...registerables)

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
    
    // Destruir o gráfico para evitar memory leaks
    if (this.chart) {
      this.chart.destroy()
    }
  }
  
  resizeChart() {
    if (this.chart) {
      this.chart.resize()
    }
  }
  
  initializeChart() {
    const canvas = this.element.querySelector('canvas')
    
    if (!canvas) return
    
    const ctx = canvas.getContext('2d')
    
    if (this.chart) {
      this.chart.destroy()
    }
    
    // Usar variáveis CSS para as fontes
    Chart.defaults.font.family = getComputedStyle(document.documentElement)
      .getPropertyValue('--chart-font-family').trim()
    
    const salesColor = 'var(--chart-color-1)'
    const leadsColor = 'var(--chart-color-2)'
    
    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.monthsValue,
        datasets: [
          {
            label: 'Vendas',
            data: this.salesValue,
            borderColor: salesColor,
            backgroundColor: this.hexToRgba(salesColor, 0.2),
            tension: 0.4,
            borderWidth: 2,
            pointRadius: 3,
            pointHoverRadius: 5
          },
          {
            label: 'Leads',
            data: this.leadsValue,
            borderColor: leadsColor,
            backgroundColor: this.hexToRgba(leadsColor, 0.2),
            tension: 0.4,
            borderWidth: 2,
            pointRadius: 3,
            pointHoverRadius: 5
          }
        ]
      },
      options: {
        responsive: this.responsiveValue,
        maintainAspectRatio: this.maintainAspectRatioValue,
        plugins: {
          legend: {
            display: false // Ocultar a legenda padrão, usamos nossa própria legenda HTML
          },
          tooltip: {
            mode: 'index',
            intersect: false,
            backgroundColor: 'var(--chart-tooltip-bg)',
            titleFont: {
              size: parseInt(getComputedStyle(document.documentElement)
                .getPropertyValue('--chart-title-size')),
              family: getComputedStyle(document.documentElement)
                .getPropertyValue('--chart-font-family').trim()
            },
            bodyFont: {
              size: parseInt(getComputedStyle(document.documentElement)
                .getPropertyValue('--chart-body-size')),
              family: getComputedStyle(document.documentElement)
                .getPropertyValue('--chart-font-family').trim()
            }
          }
        },
        scales: {
          x: {
            ticks: {
              color: 'var(--chart-font-color)',
              maxRotation: window.innerWidth < 500 ? 45 : 0,
              font: {
                size: window.innerWidth < 768 ? 
                  parseInt(getComputedStyle(document.documentElement)
                    .getPropertyValue('--chart-axis-size-mobile')) :
                  parseInt(getComputedStyle(document.documentElement)
                    .getPropertyValue('--chart-axis-size-desktop'))
              }
            },
            grid: {
              display: false
            }
          },
          y: {
            beginAtZero: true,
            ticks: {
              color: 'var(--chart-font-color)',
              font: {
                size: window.innerWidth < 768 ?
                  parseInt(getComputedStyle(document.documentElement)
                    .getPropertyValue('--chart-axis-size-mobile')) :
                  parseInt(getComputedStyle(document.documentElement)
                    .getPropertyValue('--chart-axis-size-desktop'))
              }
            },
            grid: {
              color: 'var(--chart-grid-color)'
            }
          }
        },
        interaction: {
          intersect: false,
          mode: 'index'
        }
      }
    })
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
