# Configuração para resolver problemas de Cross-Origin Resource Sharing (CORS)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # Em produção, substitua por domínios específicos em vez de '*'
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
  end
end
