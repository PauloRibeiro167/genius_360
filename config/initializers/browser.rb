# Configura quais navegadores são permitidos na aplicação

# Definir constante para verificar caminhos públicos
BROWSER_PUBLIC_PATHS = ['/public', '/']

Rails.application.config.middleware.use Browser::Middleware do
  # Ignora verificação para caminhos públicos
  # Esta verificação precisa vir antes do bloco 'allow'
  skip_if do |request|
    path = request.path
    BROWSER_PUBLIC_PATHS.any? { |public_path| path.start_with?(public_path) }
  end

  # Permite navegadores específicos para o restante
  allow do
    modern_browsers
    firefox '> 10'
    chrome '> 20'
    safari '> 6'
    opera '> 10'
    mobile
    tablet
  end

  # Não configura redirecionamento para caminhos públicos
  redirect_to '/public/unsupported-browser', unless: -> (params) {
    BROWSER_PUBLIC_PATHS.any? { |public_path| params.path.start_with?(public_path) }
  }
end
