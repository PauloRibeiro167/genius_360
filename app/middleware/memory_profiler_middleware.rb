require 'get_process_mem'

class MemoryProfilerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers, body]
  end
end
