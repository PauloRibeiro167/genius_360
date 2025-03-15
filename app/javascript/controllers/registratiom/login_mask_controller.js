import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["phone", "cpf", "password", "password_confirmation", "strengthMeter", "form", "input", "label"]
  static values = {
    checkCpfUrl: String
  }

  connect() {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => this.initializeController())
    } else {
      this.initializeController()
    }
  }

  initializeController() {
    try {
      this.initializeMasks()
      this.initializePasswordToggle()
      this.initializePasswordStrength()
      this.setupCpfValidation()
      this.initializeRequiredFields()
    } catch (error) {
      console.error('Erro durante a inicialização do controller:', error)
    }
  }

  debugTargets() {
    const targetDebugInfo = {
        phone: this.debugTarget('phone'),
        cpf: this.debugTarget('cpf'),
        password: this.debugTarget('password'),
        password_confirmation: this.debugTarget('password_confirmation'),
        strengthMeter: this.debugTarget('strengthMeter')
    }
  }

  debugTarget(targetName) {
    const hasTarget = this[`has${targetName.charAt(0).toUpperCase() + targetName.slice(1)}Target`]
    const target = this[`${targetName}Target`]
    
    return {
        exists: hasTarget,
        element: target,
        elementId: target?.id,
        elementType: target?.tagName,
        dataAttributes: target ? this.getDataAttributes(target) : null
    }
  }

  getDataAttributes(element) {
    return Array.from(element.attributes)
        .filter(attr => attr.name.startsWith('data-'))
        .reduce((acc, attr) => {
            acc[attr.name] = attr.value
            return acc
        }, {})
  }

  initializeMasks() {
    this.setupPhoneMask();
    this.setupCpfMask();
  }
  
  addSafeEventListener(element, eventType, handler) {
    if (element && typeof element.addEventListener === 'function') {
      element.addEventListener(eventType, handler)
      return true
    }
    return false
  }

  setupPhoneMask() {
    if (!this.hasPhoneTarget || !this.phoneTarget) {
        return
    }

    const applyPhoneMask = (event) => {
        if (!event || !event.target) {
            return
        }
        
        let input = event.target;
        let inputValue = input.value.replace(/\D/g, '').substring(0, 11);
        let formattedValue = '';
        
        if (inputValue.length > 0) {
            formattedValue = '(' + inputValue.substring(0, 2);
            
            if (inputValue.length > 2) {
                formattedValue += ') ' + inputValue.substring(2, 7);
            }
            
            if (inputValue.length > 7) {
                formattedValue += '-' + inputValue.substring(7, 11);
            }
        }
        
        input.value = formattedValue;
    };

    try {
        ['input', 'blur', 'focus'].forEach(eventType => {
            this.addSafeEventListener(this.phoneTarget, eventType, applyPhoneMask)
        });

        if (this.phoneTarget.value) {
            applyPhoneMask({ target: this.phoneTarget });
        }
    } catch (error) { }
  }
  
  setupCpfMask() {
    if (!this.hasCpfTarget || !this.cpfTarget) {
      return
    }

    const applyCpfMask = (event) => {
        let input = event.target;
        let inputValue = input.value.replace(/\D/g, '').substring(0, 11);
        let formattedValue = '';
        
        if (inputValue.length > 0) {
            formattedValue = inputValue.substring(0, 3);
            
            if (inputValue.length > 3) {
                formattedValue += '.' + inputValue.substring(3, 6);
            }
            
            if (inputValue.length > 6) {
                formattedValue += '.' + inputValue.substring(6, 9);
            }
            
            if (inputValue.length > 9) {
                formattedValue += '-' + inputValue.substring(9, 11);
            }
        }
        
        input.value = formattedValue;
    };
    
    ['input', 'blur', 'focus'].forEach(eventType => {
      this.addSafeEventListener(this.cpfTarget, eventType, applyCpfMask)
    });

    if (this.cpfTarget.value) {
        const event = { target: this.cpfTarget };
        applyCpfMask(event);
    }
  }

  initializePasswordToggle() {
    this.eyeOpenIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-width="2" d="M21 12c0 1.2-4.03 6-9 6s-9-4.8-9-6c0-1.2 4.03-6 9-6s9 4.8 9 6Z"/><path stroke="currentColor" stroke-width="2" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/></svg>`
    
    this.eyeClosedIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.93 13.9A4.36 4.36 0 0 1 3 12c0-1 4-6 9-6m7.6 3.8A5.07 5.07 0 0 1 21 12c0 1-3 6-9 6-.31 0-.62-.01-.92-.04M5 19 19 5m-4 7a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/></svg>`

    const togglePassword = (target, button) => {
      const type = target.getAttribute('type') === 'password' ? 'text' : 'password'
      target.setAttribute('type', type)
      button.innerHTML = type === 'password' ? this.eyeOpenIcon : this.eyeClosedIcon
    }

    if (this.hasPasswordTarget) {
      const container = this.passwordTarget.parentElement
      container.classList.add('relative')
      
      const toggleBtn = document.createElement('button')
      toggleBtn.type = 'button'
      toggleBtn.innerHTML = this.eyeOpenIcon
      toggleBtn.className = 'absolute right-3 top-[66%] transform -translate-y-1/2 text-gray-400 hover:text-gray-600'
      toggleBtn.addEventListener('click', () => togglePassword(this.passwordTarget, toggleBtn))
      
      container.appendChild(toggleBtn)
    }

    if (this.hasPassword_confirmationTarget) {
      const container = this.password_confirmationTarget.parentElement
      container.classList.add('relative')
      
      const toggleBtn = document.createElement('button')
      toggleBtn.type = 'button'
      toggleBtn.innerHTML = this.eyeOpenIcon
      toggleBtn.className = 'absolute right-3 top-[66%] transform -translate-y-1/2 text-gray-400 hover:text-gray-600'
      toggleBtn.addEventListener('click', () => togglePassword(this.password_confirmationTarget, toggleBtn))
      
      container.appendChild(toggleBtn)
    }
  }

  initializePasswordStrength() {
    if (this.hasPasswordTarget && this.hasStrengthMeterTarget) {
      this.setupPasswordValidation()
      this.passwordTarget.addEventListener('input', (e) => {
        const password = e.target.value
        this.updatePasswordRules(password)
        const strength = this.calculatePasswordStrength(password)
        this.updateStrengthMeter(strength)
      })
    }
  }

  setupPasswordValidation() {
    this.passwordRules = {
      length: { 
        regex: /.{6,}/, 
        element: document.getElementById('length-rule')
      },
      uppercase: { 
        regex: /[A-Z]/, 
        element: document.getElementById('uppercase-rule')
      },
      lowercase: { 
        regex: /[a-z]/, 
        element: document.getElementById('lowercase-rule')
      },
      number: { 
        regex: /[0-9]/, 
        element: document.getElementById('number-rule')
      },
      special: { 
        regex: /[!@#$%^&*(),.?":{}|<>]/, 
        element: document.getElementById('special-rule')
      }
    }
  }

  updatePasswordRules(password) {
    if (!password) password = ''

    Object.keys(this.passwordRules).forEach(rule => {
      const { regex, element } = this.passwordRules[rule]
      if (!element) return

      const isValid = regex.test(password)
      
      if (isValid) {
        element.classList.add('opacity-0', 'h-0', 'overflow-hidden', 'my-0')
        element.style.marginBottom = '0'
      } else {
        element.classList.remove('opacity-0', 'h-0', 'overflow-hidden', 'my-0')
        element.style.marginBottom = '0.5rem'
      }

      const icon = element.querySelector('svg')
      if (icon) {
        if (isValid) {
          icon.classList.remove('text-red-500')
          icon.classList.add('text-green-500')
        } else {
          icon.classList.add('text-red-500')
          icon.classList.remove('text-green-500')
        }
      }
    })

    const allRulesValid = Object.keys(this.passwordRules).every(rule => {
      const { regex, element } = this.passwordRules[rule]
      return element && regex.test(password)
    })

    const rulesContainer = document.querySelector('.password-rules')
    if (rulesContainer) {
      if (allRulesValid && password.length > 0) {
        rulesContainer.style.display = 'none'
      } else {
        rulesContainer.style.display = 'block'
      }
    }
  }

  calculatePasswordStrength(password) {
    let strength = 0
    
    if (password.length >= 8) strength += 1
    if (password.match(/[a-z]/)) strength += 1
    if (password.match(/[A-Z]/)) strength += 1
    if (password.match(/[0-9]/)) strength += 1
    if (password.match(/[^a-zA-Z0-9]/)) strength += 1
    
    return strength
  }

  updateStrengthMeter(strength) {
    const colors = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-blue-500', 'bg-green-500']
    const messages = ['Muito fraca', 'Fraca', 'Média', 'Forte', 'Muito forte']
    
    this.strengthMeterTarget.style.width = `${(strength / 5) * 100}%`
    this.strengthMeterTarget.className = `h-2 transition-all ${colors[strength - 1]}`
    this.strengthMeterTarget.setAttribute('title', messages[strength - 1])
  }

  setupCpfValidation() {
    if (!this.hasCpfTarget) return

    let validationInProgress = false

    this.cpfTarget.addEventListener('blur', async (event) => {
      const cpf = event.target.value.replace(/\D/g, '')
      
      if (cpf.length !== 11) {
        return
      }
      
      if (validationInProgress) return
      validationInProgress = true
      
      try {
        if (this.validateCpfFormat(cpf)) {
          this.removeError(this.cpfTarget)
        } else {
          this.showError(this.cpfTarget, 'CPF inválido')
        }
      } catch (error) {
        this.removeError(this.cpfTarget)
      } finally {
        validationInProgress = false
      }
    })
  }
  
  validateCpfFormat(cpf) {
    if (/^(\d)\1+$/.test(cpf)) return false
    
    let sum = 0
    for (let i = 0; i < 9; i++) {
      sum += parseInt(cpf.charAt(i)) * (10 - i)
    }
    let remainder = sum % 11
    let digit1 = remainder < 2 ? 0 : 11 - remainder
    
    sum = 0
    for (let i = 0; i < 10; i++) {
      sum += parseInt(cpf.charAt(i)) * (11 - i)
    }
    remainder = sum % 11
    let digit2 = remainder < 2 ? 0 : 11 - remainder
    
    return digit1 === parseInt(cpf.charAt(9)) && digit2 === parseInt(cpf.charAt(10))
  }

  showError(element, message) {
    const errorDiv = document.createElement('div')
    errorDiv.className = 'text-red-500 text-sm mt-1'
    errorDiv.textContent = message
    
    this.removeError(element)
    
    element.parentElement.appendChild(errorDiv)
    element.classList.add('border-red-500')
  }

  removeError(element) {
    const errorDiv = element.parentElement.querySelector('.text-red-500')
    if (errorDiv) {
      errorDiv.remove()
    }
    element.classList.remove('border-red-500')
  }

  initializeRequiredFields() {
    if (!this.hasInputTarget || !this.hasLabelTarget) {
      return
    }

    this.inputTargets.forEach((input, index) => {
      const label = this.labelTargets[index]
      if (!input || !label) {
        return
      }

      this.updateRequiredFieldStatus(input, label)
      
      const addSafeEventListener = (element, event, handler) => {
        if (element && typeof element.addEventListener === 'function') {
          element.addEventListener(event, handler)
        }
      }

      addSafeEventListener(input, 'input', () => {
        this.updateRequiredFieldStatus(input, label)
      })
      
      addSafeEventListener(input, 'change', () => {
        this.updateRequiredFieldStatus(input, label)
      })
    })
  }

  updateRequiredFieldStatus(input, label) {
    if (!input || !label || !input.value === undefined) {
      return
    }

    try {
      if (input.value.trim() === '') {
        label.classList.add('text-transparent', 'bg-clip-text', 'bg-gradient-to-r', 'from-purple-400', 'to-pink-300')
        label.classList.remove('text-pink-400')
      } else {
        label.classList.remove('text-transparent', 'bg-clip-text', 'bg-gradient-to-r', 'from-purple-400', 'to-pink-300')
        label.classList.add('text-pink-400')
      }
    } catch (error) { }
  }
}
