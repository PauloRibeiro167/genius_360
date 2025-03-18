begin
  puts "\n Iniciando criação de permissões..."

  stats = { criadas: 0, existentes: 0, erros: 0 }

  permissions = [
    { name: "Listar usuários" },
    { name: "Visualizar usuário" },
    { name: "Atualizar usuário" },
    { name: "Remover usuário" },

    { name: "Visualizar métricas" },
    { name: "Exportar métricas" },
    { name: "Filtrar métricas" },

    { name: "Criar demanda" },
    { name: "Listar demandas" },
    { name: "Visualizar demanda" },
    { name: "Atualizar demanda" },
    { name: "Remover demanda" },

    { name: "Listar vendas" },
    { name: "Visualizar venda" },
    { name: "Criar venda" },
    { name: "Atualizar venda" },
    { name: "Remover venda" },

    { name: "Listar finanças" },
    { name: "Visualizar finança" },
    { name: "Atualizar finança" },
    { name: "Exportar finanças" },

    { name: "Visualizar configurações" },
    { name: "Atualizar configurações" }
  ]

  permissions.each do |permission|
    begin
      perm = Permission.find_or_initialize_by(name: permission[:name])
      
      if perm.new_record?
        if perm.save
          puts "Permissão criada: #{permission[:name]}"
          stats[:criadas] += 1
        else
          puts "Erro ao criar permissão '#{permission[:name]}': #{perm.errors.full_messages.join(', ')}"
          stats[:erros] += 1
        end
      else
        puts "Permissão já existe: #{permission[:name]}"
        stats[:existentes] += 1
      end
      
    rescue ActiveRecord::RecordInvalid => e
      puts "Erro de validação ao criar permissão '#{permission[:name]}': #{e.message}"
      stats[:erros] += 1
    rescue => e
      puts "Erro inesperado ao criar permissão '#{permission[:name]}': #{e.message}"
      puts "Debug: #{e.backtrace[0..2].join("\n")}"
      stats[:erros] += 1
    end
  end

  puts "\nResumo da operação:"
  puts "Total de permissões processadas: #{permissions.size}"
  puts "Permissões criadas: #{stats[:criadas]}"
  puts "Permissões existentes: #{stats[:existentes]}"
  puts "Erros encontrados: #{stats[:erros]}"
  puts "Total de permissões no sistema: #{Permission.count}"

rescue ActiveRecord::StatementInvalid => e
  puts "\nErro de banco de dados:"
  puts "#{e.message}"
  puts "\nVerifique:"
  puts "1. A tabela 'permissions' existe"
  puts "2. Todas as migrations foram executadas"
  puts "3. O banco de dados está acessível"
  
rescue NameError => e
  puts "\nErro de definição de classe:"
  puts "#{e.message}"
  puts "\nVerifique:"
  puts "1. O modelo Permission está definido em #app/models/permission.rb"
  puts "2. O nome da classe está correto (Permission)"
  puts "3. O arquivo do modelo está no local correto"
  
rescue => e
  puts "\nErro inesperado:"
  puts "#{e.message}"
  puts "\nStack trace:"
  puts e.backtrace[0..5].map { |line| "#{line}" }.join("\n")
end
