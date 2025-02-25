// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "flowbite/dist/flowbite.turbo.js";

// Importar Chart.js corretamente
import Chart from 'chart.js/auto'
window.Chart = Chart

import "chartkick"
import "chartkick/chart.js"
import "./channels"
