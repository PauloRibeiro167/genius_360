import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selector', 'themeButton']
  static values = { 
    current: { type: String, default: 'light' },
    available: { type: Array, default: ['light', 'dark', 'purple'] }
  }
  
  connect() {
    // Verifica se o tema já foi inicializado pelo theme_initializer_controller
    const currentTheme = document.documentElement.getAttribute('data-theme')
    
    if (currentTheme) {
      this.currentValue = currentTheme
    } else {
      this.initializeTheme()
    }
    
    // Atualiza a UI para refletir o tema atual
    this.updateUI()
  }
  
  // Inicializa o tema com base no cookie ou preferência do sistema
  initializeTheme() {
    // Verifica se existe um tema salvo em cookie
    const savedTheme = this.getCookie('genius360_theme')
    
    // Se não houver tema salvo, tenta usar preferência do sistema
    if (!savedTheme) {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
      this.currentValue = prefersDark ? 'dark' : 'light'
    } else {
      this.currentValue = savedTheme
    }
    
    // Aplica o tema atual
    this.applyTheme(this.currentValue)
  }
  
  // Troca para o próximo tema na lista
  toggle() {
    const currentIndex = this.availableValue.indexOf(this.currentValue)
    const nextIndex = (currentIndex + 1) % this.availableValue.length
    const nextTheme = this.availableValue[nextIndex]
    
    this.currentValue = nextTheme
    this.applyTheme(nextTheme)
    this.updateUI()
  }
  
  // Seleciona um tema específico
  select(event) {
    const theme = event.currentTarget.dataset.theme
    
    if (this.availableValue.includes(theme)) {
      this.currentValue = theme
      this.applyTheme(theme)
      this.updateUI()
    }
  }
  
  // Aplica o tema ao documento e salva em cookie
  applyTheme(theme) {
    // Adiciona classe de transição para suavizar mudança
    document.documentElement.classList.add('theme-transition')
    
    // Remove atributos de tema anteriores
    document.documentElement.removeAttribute('data-theme')
    
    // Define o novo tema
    document.documentElement.setAttribute('data-theme', theme)
    
    // Salva a preferência do usuário em cookie (30 dias)
    this.setCookie('genius360_theme', theme, 30)
    
    // Remove a classe de transição após a mudança
    setTimeout(() => {
      document.documentElement.classList.remove('theme-transition')
    }, 300)
    
    // Dispara evento para informar outros componentes sobre a mudança
    window.dispatchEvent(new CustomEvent('themeChanged', { 
      detail: { theme: theme } 
    }))
  }
  
  // Atualiza a interface do usuário para refletir o tema atual
  updateUI() {
    // Atualiza botões de tema, se existirem
    if (this.hasThemeButtonTarget) {
      this.themeButtonTargets.forEach(button => {
        const buttonTheme = button.dataset.theme
        
        // Marca o botão ativo
        if (buttonTheme === this.currentValue) {
          button.setAttribute('aria-current', 'true')
          button.classList.add('active')
        } else {
          button.removeAttribute('aria-current')
          button.classList.remove('active')
        }
      })
    }
    
    // Atualiza seletor, se existir
    if (this.hasSelectorTarget) {
      this.selectorTarget.value = this.currentValue
    }
  }
  
  // Utilitário para definir cookie
  setCookie(name, value, days) {
    let expires = ''
    
    if (days) {
      const date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = '; expires=' + date.toUTCString()
    }
    
    document.cookie = name + '=' + (value || '') + expires + '; path=/'
  }
  
  // Utilitário para obter valor de cookie
  getCookie(name) {
    const nameEQ = name + '='
    const ca = document.cookie.split(';')
    
    for (let i = 0; i < ca.length; i++) {
      let c = ca[i]
      while (c.charAt(0) === ' ') c = c.substring(1, c.length)
      if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length)
    }
    
    return null
  }
}
