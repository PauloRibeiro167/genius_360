require 'colorize'

begin
  puts "\nIniciando criação de hierarquias...".colorize(:green)

  # Estatísticas
  stats = { criadas: 0, existentes: 0, erros: 0 }

  hierarquias = [
    { nome: "Diretoria", nivel: 1, descricao: "Nível executivo" },
    { nome: "Gerência", nivel: 2, descricao: "Nível gerencial" },
    { nome: "Coordenação", nivel: 3, descricao: "Nível de coordenação" },
    { nome: "Operacional", nivel: 4, descricao: "Nível operacional" }
  ]

  hierarquias.each do |h|
    begin
      hierarquia = Hierarquia.find_or_initialize_by(nome: h[:nome])
      
      if hierarquia.new_record?
        if hierarquia.update(h)
          puts "✓ Hierarquia criada: #{h[:nome]}".colorize(:green)
          stats[:criadas] += 1
        else
          puts "✗ Erro ao criar hierarquia '#{h[:nome]}': #{hierarquia.errors.full_messages.join(', ')}".colorize(:red)
          stats[:erros] += 1
        end
      else
        puts "• Hierarquia já existe: #{h[:nome]}".colorize(:blue)
        stats[:existentes] += 1
      end
      
    rescue ActiveRecord::RecordInvalid => e
      puts "✗ Erro de validação ao criar hierarquia '#{h[:nome]}': #{e.message}".colorize(:red)
      stats[:erros] += 1
    rescue => e
      puts "✗ Erro inesperado ao criar hierarquia '#{h[:nome]}': #{e.message}".colorize(:red)
      puts e.backtrace[0..2].map(&:colorize).join("\n")
      stats[:erros] += 1
    end
  end

  # Exibir estatísticas finais
  puts "\nResumo da operação:".colorize(:blue)
  puts "→ Total de hierarquias processadas: #{hierarquias.size}".colorize(:blue)
  puts "→ Hierarquias criadas: #{stats[:criadas]}".colorize(:green)
  puts "→ Hierarquias existentes: #{stats[:existentes]}".colorize(:blue)
  puts "→ Erros encontrados: #{stats[:erros]}".colorize(:red)
  puts "→ Total de hierarquias no sistema: #{Hierarquia.count}".colorize(:blue)

rescue ActiveRecord::StatementInvalid => e
  puts "\n✗ Erro de banco de dados:".colorize(:red)
  puts "→ #{e.message}".colorize(:red)
  puts "\nVerifique se:".colorize(:blue)
  puts "  1. A tabela 'hierarquias' existe".colorize(:blue)
  puts "  2. Todas as migrations foram executadas".colorize(:blue)
  puts "  3. O banco de dados está acessível".colorize(:blue)
  
rescue NameError => e
  puts "\n✗ Erro de definição de classe:".colorize(:red)
  puts "→ #{e.message}".colorize(:red)
  puts "\nVerifique se:".colorize(:blue)
  puts "  1. O modelo Hierarquia está definido em app/models/hierarquia.rb".colorize(:blue)
  puts "  2. O nome da classe está correto (Hierarquia)".colorize(:blue)
  puts "  3. O arquivo do modelo está no local correto".colorize(:blue)
  
rescue => e
  puts "\n✗ Erro inesperado:".colorize(:red)
  puts "→ #{e.message}".colorize(:red)
  puts "\nStack trace:".colorize(:blue)
  puts e.backtrace[0..5].map { |line| line.colorize(:red) }
end