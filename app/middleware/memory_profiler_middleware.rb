begin
  require "get_process_mem"

  class MemoryProfilerMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      memory_before = GetProcessMem.new.mb
      status, headers, response = @app.call(env)
      memory_after = GetProcessMem.new.mb

      Rails.logger.info "[Memory Usage] Before: #{memory_before.round(2)}MB, After: #{memory_after.round(2)}MB, Diff: #{(memory_after - memory_before).round(2)}MB"

      [ status, headers, response ]
    rescue StandardError => e
      Rails.logger.error "Erro no MemoryProfilerMiddleware: #{e.message}"
      @app.call(env)
    end
  end
rescue LoadError => e
  Rails.logger.warn "MemoryProfilerMiddleware não disponível: #{e.message}"
end
