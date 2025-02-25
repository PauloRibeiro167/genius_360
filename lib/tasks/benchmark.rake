namespace :benchmark do
  desc "Executa teste de carga na aplicação"
  task load_test: :environment do
    require 'net/http'
    require 'benchmark'
    require 'get_process_mem'

    def make_request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5  # timeout para abrir conexão
      http.read_timeout = 10 # timeout para ler resposta
      
      begin
        response = http.get(uri.path)
        return response.code
      rescue Errno::ECONNREFUSED => e
        puts "Conexão recusada: #{e.message}"
        return "connection_refused"
      rescue Net::ReadTimeout, Net::OpenTimeout => e
        return "timeout"
      rescue StandardError => e
        puts "Erro na requisição: #{e.class} - #{e.message}" # Adiciona log do erro
        return "error"
      end
    end

    mem = GetProcessMem.new
    start_memory = mem.mb
    concurrent_users = 10
    total_requests = 10
    uri = URI('http://localhost:3000/') 

    puts "\n=== Iniciando teste de carga ==="
    puts "Memória inicial: #{start_memory.round(2)} MB"
    puts "Usuários simultâneos: #{concurrent_users}"
    puts "Total de requisições: #{total_requests}"

    results = {success: 0, timeout: 0, error: 0}
    
    elapsed_time = Benchmark.realtime do
      threads = concurrent_users.times.map do
        Thread.new do
          (total_requests / concurrent_users).times do
            result = make_request(uri)
            results[result == "200" ? :success : result.to_sym] += 1
          end
        end
      end
      threads.each(&:join)
    end

    end_memory = mem.mb
    # peak_memory = mem.peak_mb # Comentado para evitar o erro
    requests_per_second = total_requests / elapsed_time

    puts "\n=== Resultados ==="
    puts "Tempo total: #{elapsed_time.round(2)} segundos"
    puts "Requisições por segundo: #{requests_per_second.round(2)}"
    puts "Tempo médio por requisição: #{(elapsed_time / total_requests * 1000).round(2)} ms"
    puts "\n=== Estatísticas de Requisições ==="
    puts "Sucesso: #{results[:success]}"
    puts "Timeouts: #{results[:timeout]}"
    puts "Erros: #{results[:error]}"
    puts "\n=== Uso de Memória ==="
    puts "Memória inicial: #{start_memory.round(2)} MB"
    puts "Memória final: #{end_memory.round(2)} MB"
    puts "Aumento de memória: #{(end_memory - start_memory).round(2)} MB"
    # puts "Pico de memória: #{peak_memory.round(2)} MB" # Comentado para evitar o erro
  end
end