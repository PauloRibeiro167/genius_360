require 'colorize'
require 'benchmark'

begin
  start_time = Time.now
  puts "\n[#{start_time.strftime('%H:%M:%S')}] Iniciando limpeza do banco de dados...".colorize(:cyan)
  
  models = {
    PerfilPermission => "Permissões de perfis",
    Permission => "Permissões",
    User => "Usuários", 
    Perfil => "Perfis"
  }

  stats = { 
    removidos: 0, 
    erros: 0,
    modelos_processados: 0,
    seeds_carregados: 0
  }

  # Verificação de dependências
  puts "\nVerificando dependências...".colorize(:yellow)
  models.each_key do |model|
    unless defined?(model)
      puts "⚠️  Modelo #{model} não encontrado!".colorize(:red)
      exit 1
    end
  end

  # Limpeza do banco
  models.each do |model, name|
    begin
      count = model.count
      print "→ Removendo #{name}... ".colorize(:blue)
      model.destroy_all
      stats[:removidos] += count
      stats[:modelos_processados] += 1
      puts "✓ (#{count} registros)".colorize(:green)
    rescue => e
      stats[:erros] += 1
      puts "✗".colorize(:red)
      puts "  #{e.message}".colorize(:red)
    end
  end

  puts "\nResumo da limpeza:".colorize(:blue)
  puts "→ Registros removidos: #{stats[:removidos]}".colorize(:green)
  puts "→ Erros encontrados: #{stats[:erros]}".colorize(:red)

  puts "\nCarregando seeds...".colorize(:blue)
  Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |file|
    begin
      print "→ Processando #{File.basename(file)}... ".colorize(:blue)
      require file
      stats[:seeds_carregados] += 1
      puts "✓".colorize(:green)
    rescue => e
      stats[:erros] += 1
      puts "✗".colorize(:red)
      puts "  Erro: #{e.message}".colorize(:red)
    end
  end

  # Adicionar resumo final melhorado
  end_time = Time.now
  duration = (end_time - start_time).round(2)
  
  puts "\n📊 Relatório Final:".colorize(:cyan)
  puts "→ Tempo total: #{duration}s".colorize(:blue)
  puts "→ Modelos processados: #{stats[:modelos_processados]}/#{models.size}".colorize(:blue)
  puts "→ Registros removidos: #{stats[:removidos]}".colorize(:green)
  puts "→ Seeds carregados: #{stats[:seeds_carregados]}".colorize(:green)
  puts "→ Erros encontrados: #{stats[:erros]}".colorize(stats[:erros] > 0 ? :red : :green)

rescue => e
  puts "\n❌ Erro fatal durante o seed:".colorize(:red)
  puts "→ #{e.message}".colorize(:red)
  puts e.backtrace[0..2].map { |line| "  #{line}".colorize(:red) }
end
