// Arquivo para garantir que Chart.js e Chartkick estejam corretamente configurados
document.addEventListener('DOMContentLoaded', function() {
  // Verifica se Chart.js está disponível globalmente
  if (typeof Chart === 'undefined') {
    console.error('Chart.js não está disponível. Verifique se você incluiu o arquivo Chart.bundle.js corretamente.');
  }
  
  // Verifica se Chartkick está disponível globalmente
  if (typeof Chartkick === 'undefined') {
    console.error('Chartkick não está disponível. Verifique se você incluiu o arquivo chartkick.js corretamente.');
  } else if (typeof Chart !== 'undefined') {
    // Configura o Chartkick para usar o Chart.js
    Chartkick.use(Chart);
  }
});
