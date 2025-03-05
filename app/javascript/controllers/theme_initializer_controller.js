import { Controller } from "@hotwired/stimulus"

// Função auto-executável para inicializar o tema antes do controller
(function() {
  const nameEQ = 'genius360_theme='
  const ca = document.cookie.split(';')
  let savedTheme = null
  
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i]
    while (c.charAt(0) === ' ') c = c.substring(1, c.length)
    if (c.indexOf(nameEQ) === 0) {
      savedTheme = c.substring(nameEQ.length, c.length)
      break
    }
  }

  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  const theme = savedTheme || (prefersDark ? 'dark' : 'light')
  
  document.documentElement.setAttribute('data-theme', theme)
})()

export default class extends Controller {
  initialize() {
    // O tema já foi inicializado pela função auto-executável acima
  }
  
  connect() {
    // Este controller agora só lida com mudanças dinâmicas do tema
  }
  
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
