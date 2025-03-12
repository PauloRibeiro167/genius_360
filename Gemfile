source "https://rubygems.org"

# Use Rails mais recente
gem "rails", "~> 8.0.1"
# Pipeline de ativos moderna para Rails
gem "propshaft"
# Use o servidor web Puma
gem "puma", ">= 5.0"
# Gem consultas no banco dedados
gem "ransack", ">= 4.3.0"
# simplifica o uso de formulários
gem "simple_form", "~> 5.1"
# Gem para paginação
gem "kaminari", "~> 1.2"
# Empacota e transpila JavaScript
gem "jsbundling-rails"
# Melhora o formato dos logs
gem "lograge"
# Extensão Lograge para incluir queries SQL nos logs
gem "lograge-sql"
# Acelerador de página estilo SPA do Hotwire
gem "turbo-rails"
# Framework JavaScript modesto do Hotwire
gem "stimulus-rails"
# Frontend e Assets
gem "cssbundling-rails"     # Empacota e processa CSS
gem "tailwindcss-rails"     # Framework CSS
gem "breadcrumbs_on_rails", "~> 4.1"  # Gerenciamento de breadcrumbs

# Notificações
gem "noticed", "~> 1.6"

# API e JSON
gem "jbuilder"              # Construa APIs JSON facilmente

# Autenticação e Autorização
gem "devise"                # Autenticação flexível
gem "pundit"                # Autorização baseada em políticas
gem "lockbox"               # Criptografia de dados
gem "blind_index"           # Busca segura em dados criptografados
gem "discard", "~> 1.2"     # Soft delete para modelos

# Cache e Performance
gem "solid_cache"           # Cache baseado em banco de dados
gem "solid_queue"           # Active Job baseado em banco de dados
gem "solid_cable"           # Action Cable baseado em banco de dados
gem "bootsnap", require: false  # Reduz tempos de inicialização
gem "thruster", require: false  # Cache/compressão de ativos HTTP

# Deploy e DevOps
gem "kamal", require: false # Deploy com containers Docker

# Gems específicas para Windows
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Especificar versão do stringio para evitar avisos
gem "stringio", "~> 3.1.3"

# Gems Opcionais (comentadas)
# gem "bcrypt", "~> 3.1.7"           # Senhas seguras
# gem "image_processing", "~> 1.2"    # Transformação de imagens

# Banco de dados PostgreSQL
gem "pg"

# Redis para caching e Sidekiq
gem "redis", "~> 4.0"

# Sidekiq para background jobs
gem "sidekiq"

# Ferramentas de monitoramento (opcional)
gem "newrelic_rpm"
gem "skylight"

# Armazenamento de arquivos (exemplo com Amazon S3)
gem "aws-sdk-s3", require: false

gem "csv"

gem "chartkick"
gem "groupdate" # opcional, útil para agrupar dados por data

gem 'browser'

# Security
gem 'secure_headers', '~> 6.5'

group :development, :test do
  # Desenvolvimento e Testes
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "brakeman", require: false      # Análise de segurança
  gem "rubocop-rails-omakase", require: false  # Linting
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov", require: false
  gem "rspec-rails", "~> 6.1.0"
  gem "factory_bot_rails", "~> 6.4.0"
  gem "faker", "~> 3.2.0"
end

group :development do
  # Console em páginas de exceção [https://github.com/rails/web-console]
  gem "foreman"
  gem "web-console"
  # Adiciona badges de velocidade [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"
  gem "spring"
  gem "ruby-lsp", require: false
  gem "solargraph", require: false
  gem "get_process_mem"
end

group :production do
  # Gems específicas para produção
  gem "rails_12factor"
  gem "get_process_mem"
end

group :test do
  # Testes de Sistema
  gem "capybara", "~> 3.39.0"
  gem "selenium-webdriver", "~> 4.10.0"
  gem "webdrivers", "~> 5.3.0"
  gem "erb_lint", "~> 0.5.0"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "debase", "~> 0.2.4", require: false
end
