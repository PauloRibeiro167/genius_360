require 'colorize'
require 'benchmark'
require_relative './seeds/logger'

SeedLogger.info("Iniciando limpeza do banco de dados...")

begin
  start_time = Time.now
  
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
  SeedLogger.info("Verificando dependências...")
  models.each_key do |model|
    unless defined?(model)
      SeedLogger.erro("Modelo #{model} não encontrado!")
      exit 1
    end
  end

  # Limpeza do banco
  models.each do |model, name|
    begin
      count = model.count
      SeedLogger.info("Removendo #{name}...")
      model.destroy_all
      stats[:removidos] += count
      stats[:modelos_processados] += 1
      SeedLogger.sucesso("#{count} registros removidos")
    rescue => e
      stats[:erros] += 1
      SeedLogger.erro("Falha ao remover #{name}: #{e.message}")
    end
  end

  # Carregando seeds
  SeedLogger.info("\nCarregando seeds...")
  total_seeds = Dir[Rails.root.join('db', 'seeds', '*.rb')].size
  
  Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each_with_index do |file, index|
    begin
      SeedLogger.info("Processando #{File.basename(file)}...")
      require file
      stats[:seeds_carregados] += 1
      SeedLogger.exibir_barra_progresso(index + 1, total_seeds, "Seeds")
    rescue => e
      stats[:erros] += 1
      SeedLogger.erro("Erro ao processar #{File.basename(file)}: #{e.message}")
    end
  end

  # Relatório Final
  end_time = Time.now
  duration = (end_time - start_time).round(2)
  
  SeedLogger.info("\n=== Relatório Final ===")
  SeedLogger.info("Tempo total: #{duration}s")
  SeedLogger.info("Modelos processados: #{stats[:modelos_processados]}/#{models.size}")
  SeedLogger.sucesso("Registros removidos: #{stats[:removidos]}")
  SeedLogger.sucesso("Seeds carregados: #{stats[:seeds_carregados]}")
  
  if stats[:erros] > 0
    SeedLogger.erro("Erros encontrados: #{stats[:erros]}")
  else
    SeedLogger.sucesso("Nenhum erro encontrado")
  end

rescue => e
  SeedLogger.erro("Erro fatal durante o seed:")
  SeedLogger.erro(e.message)
  SeedLogger.erro(e.backtrace[0..2].join("\n"))
end
