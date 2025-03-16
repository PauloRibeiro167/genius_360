begin
  puts "\nIniciando criação de perfis..."

  perfis = %w[
    Super Admin
    Analista de Dados
    Gerente Comercial
    Gerente Executivo
    Diretor Executivo
    Digitador
    Gerente de Marketing
    Gerente de Estrategia
    Supervisor
    Monitor de Fraudes
    Gestor de CRM
  ].freeze

  # Contador para estatísticas
  stats = { criados: 0, existentes: 0, erros: 0 }

  # Criar os perfis no banco de dados
  perfis.each do |nome|
    begin
      perfil = Perfil.find_or_initialize_by(name: nome)
      
      if perfil.new_record?
        if perfil.save
          puts "✓ Perfil criado: #{nome}"
          stats[:criados] += 1
        else
          puts "✗ Erro ao criar perfil '#{nome}': #{perfil.errors.full_messages.join(', ')}"
          stats[:erros] += 1
        end
      else
        puts "• Perfil já existe: #{nome}"
        stats[:existentes] += 1
      end

    rescue ActiveRecord::RecordInvalid => e
      puts "✗ Erro de validação ao criar perfil '#{nome}': #{e.message}"
      stats[:erros] += 1
    rescue => e
      puts "✗ Erro inesperado ao criar perfil '#{nome}': #{e.message}"
      puts e.backtrace[0..2]
      stats[:erros] += 1
    end
  end

  # Exibir estatísticas finais
  puts "\nResumo da operação:"
  puts "→ Total de perfis processados: #{perfis.size}"
  puts "→ Perfis criados: #{stats[:criados]}"
  puts "→ Perfis existentes: #{stats[:existentes]}"
  puts "→ Erros encontrados: #{stats[:erros]}"
  puts "→ Total de perfis no sistema: #{Perfil.count}"

rescue ActiveRecord::StatementInvalid => e
  puts "\n✗ Erro de banco de dados:"
  puts "→ #{e.message}"
  puts "\nVerifique se:"
  puts "  1. A tabela 'perfis' existe"
  puts "  2. Todas as migrations foram executadas"
  puts "  3. O banco de dados está acessível"
  
rescue NameError => e
  puts "\n✗ Erro de definição de classe:"
  puts "→ #{e.message}"
  puts "\nVerifique se:"
  puts "  1. O modelo Perfil está definido em app/models/perfil.rb"
  puts "  2. O nome da classe está correto (Perfil)"
  puts "  3. O arquivo do modelo está no local correto"
  
rescue => e
  puts "\n✗ Erro inesperado:"
  puts "→ #{e.message}"
  puts "\nStack trace:"
  puts e.backtrace[0..5]
end
