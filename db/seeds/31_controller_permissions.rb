begin
    puts "\n Iniciando criação de Controller Permissions..."

    stats = { criadas: 0, erros: 0 }

    controller_permissions = [
        { controller_name: "users", action_name: "index", description: "Listagem de usuários" },
        { controller_name: "users", action_name: "show", description: "Visualização de usuário" },
        { controller_name: "users", action_name: "create", description: "Criação de usuário" },
        { controller_name: "users", action_name: "update", description: "Atualização de usuário" },
        { controller_name: "users", action_name: "destroy", description: "Remoção de usuário" },

        { controller_name: "metrics", action_name: "index", description: "Visualização de métricas" },
        { controller_name: "metrics", action_name: "export", description: "Exportação de métricas" },
        { controller_name: "metrics", action_name: "filter", description: "Filtragem de métricas" },

        { controller_name: "marketing_demands", action_name: "index", description: "Listagem de demandas" },
        { controller_name: "marketing_demands", action_name: "show", description: "Visualização de demanda" },
        { controller_name: "marketing_demands", action_name: "create", description: "Criação de demanda" },
        { controller_name: "marketing_demands", action_name: "update", description: "Atualização de demanda" },
        { controller_name: "marketing_demands", action_name: "destroy", description: "Remoção de demanda" },

        { controller_name: "sales", action_name: "index", description: "Listagem de vendas" },
        { controller_name: "sales", action_name: "show", description: "Visualização de venda" },
        { controller_name: "sales", action_name: "create", description: "Criação de venda" },
        { controller_name: "sales", action_name: "update", description: "Atualização de venda" },
        { controller_name: "sales", action_name: "destroy", description: "Remoção de venda" },

        { controller_name: "finance", action_name: "index", description: "Listagem de finanças" },
        { controller_name: "finance", action_name: "show", description: "Visualização de finança" },
        { controller_name: "finance", action_name: "update", description: "Atualização de finança" },
        { controller_name: "finance", action_name: "export", description: "Exportação de finanças" },

        { controller_name: "settings", action_name: "show", description: "Visualização de configurações" },
        { controller_name: "settings", action_name: "update", description: "Atualização de configurações" }
    ]

    controller_permissions.each do |permission|
        begin
            controller_permission = ControllerPermission.create!(permission)
            puts "Criada permissão: #{permission[:controller_name]}##{permission[:action_name]}"
            stats[:criadas] += 1
            
        rescue ActiveRecord::RecordInvalid => e
            puts "Erro de validação: #{e.message}"
            puts "Debug: #{permission.inspect}"
            stats[:erros] += 1
            
        rescue => e
            puts "Erro inesperado: #{e.message}"
            puts "Debug: #{e.backtrace[0..2].join("\n")}"
            stats[:erros] += 1
        end
    end

    puts "\nResumo da operação:"
    puts "Total de permissões processadas: #{controller_permissions.size}"
    puts "Permissões criadas com sucesso: #{stats[:criadas]}"
    puts "Erros encontrados: #{stats[:erros]}"
    puts "Total de permissões no sistema: #{ControllerPermission.count}"

rescue ActiveRecord::StatementInvalid => e
    puts "\nErro de banco de dados:"
    puts "#{e.message}"
    puts "\nVerifique:"
    puts "1. A tabela 'controller_permissions' existe"
    puts "2. Todas as migrations foram executadas"
    puts "3. O banco de dados está acessível"
    
rescue => e
    puts "\nErro inesperado:"
    puts "#{e.message}"
    puts "Debug: #{e.backtrace[0..2].join("\n")}"
end
