begin
  puts "\nIniciando criação de permissões..."
  
  permissions = [
    # UsersController
    { name: "Listar usuários" },
    { name: "Visualizar usuário" },
    { name: "Atualizar usuário" },
    { name: "Remover usuário" },

    # MetricsController
    { name: "Visualizar métricas" },
    { name: "Exportar métricas" },
    { name: "Filtrar métricas" },

    # MarketingDemandsController
    { name: "Criar demanda" },
    { name: "Listar demandas" },
    { name: "Visualizar demanda" },
    { name: "Atualizar demanda" },
    { name: "Remover demanda" },

    # SalesController
    { name: "Listar vendas" },
    { name: "Visualizar venda" },
    { name: "Criar venda" },
    { name: "Atualizar venda" },
    { name: "Remover venda" },

    # FinanceController
    { name: "Listar finanças" },
    { name: "Visualizar finança" },
    { name: "Atualizar finança" },
    { name: "Exportar finanças" },

    # SettingsController
    { name: "Visualizar configurações" },
    { name: "Atualizar configurações" }
  ]

  permissions.each do |permission|
    begin
      perm = Permission.find_or_initialize_by(name: permission[:name])
      
      if perm.new_record?
        if perm.save
          puts "✓ Permissão criada: #{permission[:name]}"
        else
          puts "✗ Erro ao criar permissão '#{permission[:name]}': #{perm.errors.full_messages.join(', ')}"
        end
      else
        puts "• Permissão já existe: #{permission[:name]}"
      end
      
    rescue ActiveRecord::RecordInvalid => e
      puts "✗ Erro de validação ao criar permissão '#{permission[:name]}']: #{e.message}"
    rescue => e
      puts "✗ Erro inesperado ao criar permissão '#{permission[:name]}']: #{e.message}"
      puts e.backtrace[0..5]
    end
  end

  total_permissions = Permission.count
  puts "\nProcesso finalizado!"
  puts "Total de permissões no sistema: #{total_permissions}"

rescue ActiveRecord::StatementInvalid => e
  puts "\n✗ Erro de banco de dados:"
  puts "→ #{e.message}"
  puts "Verifique se:"
  puts "  1. A tabela 'permissions' existe"
  puts "  2. Todas as migrations foram executadas"
  puts "  3. O banco de dados está acessível"
  
rescue NameError => e
  puts "\n✗ Erro de definição de classe:"
  puts "→ #{e.message}"
  puts "Verifique se:"
  puts "  1. O modelo Permission está definido em app/models/permission.rb"
  puts "  2. O nome da classe está correto (Permission)"
  
rescue => e
  puts "\n✗ Erro inesperado:"
  puts "→ #{e.message}"
  puts "Stack trace:"
  puts e.backtrace[0..5]
end