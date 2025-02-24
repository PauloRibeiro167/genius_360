require 'get_process_mem'

class MemoryProfilerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    mem = GetProcessMem.new
    start_memory = mem.mb
    
    MemoryProfiler.start
    status, headers, body = @app.call(env)
    
    if Rails.env.development?
      report = MemoryProfiler.stop
      end_memory = mem.mb
      
      # Salva o relatório em um arquivo
      File.open("log/memory_#{Time.now.strftime('%Y%m%d_%H%M%S')}.log", 'w') do |file|
        file.puts "====== Relatório de Uso de Memória ======"
        file.puts "Memória RAM Total em Uso: #{end_memory.round(2)} MB"
        file.puts "Memória Usada nesta Requisição: #{(end_memory - start_memory).round(2)} MB"
        file.puts "Pico de Memória: #{mem.peak_mb.round(2)} MB"
        file.puts "\n=== Detalhes da Alocação ==="
        report.pretty_print(to_file: file, color_output: true)
      end
      
      # Imprime estatísticas no console
      puts "\n======= Métricas de Memória RAM ======="
      puts "Memória RAM Total em Uso: #{end_memory.round(2)} MB"
      puts "Memória Usada nesta Requisição: #{(end_memory - start_memory).round(2)} MB"
      puts "Pico de Memória: #{mem.peak_mb.round(2)} MB"
      puts "-------------------------------------"
    end
    
    [status, headers, body]
  end
end
