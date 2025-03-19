import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chart"]
  static values = { 
    data: Object,
    options: Object
  }

  connect() {
    // Tentamos usar Chartkick ou carregamos via Rails asset paths
    this.tryRenderChart();
  }

  tryRenderChart() {
    // Verifica se o Chartkick e Chart.js já estão disponíveis
    if (typeof Chartkick !== 'undefined' && typeof Chart !== 'undefined' && typeof Chartkick.BarChart !== 'undefined') {
      this.renderChart();
    } else {
      // Define contador de tentativas
      this.attempts = this.attempts || 0;
      this.attempts++;
      
      if (this.attempts <= 5) {
        console.warn(`Aguardando Chartkick (tentativa ${this.attempts}/5)...`);
        // Tenta carregar os scripts dinamicamente se não estiverem disponíveis após algumas tentativas
        if (this.attempts >= 3) {
          this.loadChartScripts();
        }
        // Tenta novamente após um intervalo
        setTimeout(() => this.tryRenderChart(), 500);
      } else {
        console.error('Não foi possível carregar o Chartkick após várias tentativas');
        // Mostrar uma mensagem no gráfico indicando o erro
        if (this.hasChartTarget) {
          this.chartTarget.innerHTML = '<div class="text-center p-4"><p class="text-red-500">Não foi possível carregar o gráfico. Recarregue a página ou contate o suporte.</p></div>';
        }
      }
    }
  }
  
  loadChartScripts() {
    // Lista de possíveis caminhos para os scripts
    const paths = {
      chart: [
        '/assets/chart.js',
        '/assets/builds/chart.js',
        '/builds/chart.js',
        '/packs/js/chart.js',
        '/node_modules/chart.js/dist/chart.umd.js'
      ],
      chartkick: [
        '/assets/chartkick.js',
        '/assets/builds/chartkick.js',
        '/builds/chartkick.js',
        '/packs/js/chartkick.js',
        '/node_modules/chartkick/dist/chartkick.js'
      ]
    };

    if (typeof Chart === 'undefined' && !document.getElementById('chart-js-script')) {
      this.loadScript('chart-js-script', paths.chart);
    }
    
    if (typeof Chartkick === 'undefined' && !document.getElementById('chartkick-script')) {
      this.loadScript('chartkick-script', paths.chartkick);
    }
  }

  loadScript(id, paths, pathIndex = 0) {
    if (pathIndex >= paths.length) {
      console.error(`Não foi possível carregar o script ${id} em nenhum dos caminhos disponíveis`);
      return;
    }

    const script = document.createElement('script');
    script.id = id;
    script.src = paths[pathIndex];
    script.onload = () => console.log(`Script ${id} carregado com sucesso de ${paths[pathIndex]}`);
    script.onerror = () => {
      console.warn(`Falha ao carregar ${id} de ${paths[pathIndex]}. Tentando próximo caminho...`);
      this.loadScript(id, paths, pathIndex + 1);
    };
    document.head.appendChild(script);
  }

  renderChart() {
    if (!this.hasDataValue) {
      console.warn('Dados não disponíveis para renderizar o gráfico');
      return;
    }
    
    if (!this.hasChartTarget) {
      console.warn('Elemento alvo do gráfico não encontrado');
      return;
    }
    
    try {
      console.log('Renderizando gráfico com dados:', this.dataValue);
      new Chartkick.BarChart(this.chartTarget, this.dataValue, this.optionsValue);
    } catch (error) {
      console.error('Erro ao renderizar o gráfico:', error);
      this.chartTarget.innerHTML = '<div class="text-center p-4"><p class="text-red-500">Erro ao renderizar o gráfico: ' + error.message + '</p></div>';
    }
  }
}
