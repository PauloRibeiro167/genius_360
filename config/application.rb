require_relative "boot"
require_relative "../app/middleware/memory_profiler_middleware"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Genius360
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `gems`, and `engines`.
    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = [ :'pt-BR', :en ]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # require 'memory_profiler_middleware' # Removed explicit require

    config.middleware.use MemoryProfilerMiddleware if Rails.env.development?
    config.eager_load_paths << Rails.root.join("app/middleware")
    config.autoload_paths << Rails.root.join("app/middleware")
    config.autoload_paths += %W[
      #{config.root}/app/controllers
      #{config.root}/app/notifications
    ]

    # Remover configuração duplicada de API
    # config.autoload_paths += %W[
    #   #{config.root}/app/controllers/api
    # ]

    # Configurar MIME types para fontes
    config.middleware.insert_before 0, Rack::Sendfile
    config.middleware.use Rack::Static,
      urls: [ "/fonts" ],
      root: "app/assets"

    # Desativar verificação de navegador no ambiente de desenvolvimento
    if Rails.env.development?
      config.middleware.delete Browser::Middleware
    end
  end
end
