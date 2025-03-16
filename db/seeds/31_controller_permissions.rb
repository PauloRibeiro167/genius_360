require 'colorize'

begin
    puts "\n Iniciando criação de Controller Permissions...".colorize(:blue)

    # Estatísticas de processamento
    stats = { criadas: 0, erros: 0 }

    # Definição das permissões de controller
    controller_permissions = [
        # UsersController
        { controller_name: "users", action_name: "index", description: "Listagem de usuários" },
        { controller_name: "users", action_name: "show", description: "Visualização de usuário" },
        { controller_name: "users", action_name: "create", description: "Criação de usuário" },
        { controller_name: "users", action_name: "update", description: "Atualização de usuário" },
        { controller_name: "users", action_name: "destroy", description: "Remoção de usuário" },

        # MetricsController
        { controller_name: "metrics", action_name: "index", description: "Visualização de métricas" },
        { controller_name: "metrics", action_name: "export", description: "Exportação de métricas" },
        { controller_name: "metrics", action_name: "filter", description: "Filtragem de métricas" },

        # MarketingDemandsController
        { controller_name: "marketing_demands", action_name: "index", description: "Listagem de demandas" },
        { controller_name: "marketing_demands", action_name: "show", description: "Visualização de demanda" },
        { controller_name: "marketing_demands", action_name: "create", description: "Criação de demanda" },
        { controller_name: "marketing_demands", action_name: "update", description: "Atualização de demanda" },
        { controller_name: "marketing_demands", action_name: "destroy", description: "Remoção de demanda" },

        # SalesController
        { controller_name: "sales", action_name: "index", description: "Listagem de vendas" },
        { controller_name: "sales", action_name: "show", description: "Visualização de venda" },
        { controller_name: "sales", action_name: "create", description: "Criação de venda" },
        { controller_name: "sales", action_name: "update", description: "Atualização de venda" },
        { controller_name: "sales", action_name: "destroy", description: "Remoção de venda" },

        # FinanceController
        { controller_name: "finance", action_name: "index", description: "Listagem de finanças" },
        { controller_name: "finance", action_name: "show", description: "Visualização de finança" },
        { controller_name: "finance", action_name: "update", description: "Atualização de finança" },
        { controller_name: "finance", action_name: "export", description: "Exportação de finanças" },

        # SettingsController
        { controller_name: "settings", action_name: "show", description: "Visualização de configurações" },
        { controller_name: "settings", action_name: "update", description: "Atualização de configurações" }
    ]

    # Processamento das permissões
    controller_permissions.each do |permission|
        begin
            controller_permission = ControllerPermission.create!(permission)
            puts "🟢 Criada permissão: #{permission[:controller_name]}##{permission[:action_name]}".colorize(:green)
            stats[:criadas] += 1
            
        rescue ActiveRecord::RecordInvalid => e
            puts " Erro de validação: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{permission.inspect}".colorize(:magenta)
            stats[:erros] += 1
            
        rescue => e
            puts " Erro inesperado: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
            stats[:erros] += 1
        end
    end

    # Exibição do resumo da operação
    puts "\n Resumo da operação:".colorize(:cyan)
    puts " → Total de permissões processadas: #{controller_permissions.size}".colorize(:blue)
    puts "🟢 → Permissões criadas com sucesso: #{stats[:criadas]}".colorize(:green)
    puts " → Erros encontrados: #{stats[:erros]}".colorize(:red)
    puts "⚫ → Total de permissões no sistema: #{ControllerPermission.count}".colorize(:light_black)

rescue ActiveRecord::StatementInvalid => e
    puts "\n Erro de banco de dados:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟡 Verifique:".colorize(:yellow)
    puts "    1. A tabela 'controller_permissions' existe".colorize(:yellow)
    puts "    2. Todas as migrations foram executadas".colorize(:yellow)
    puts "    3. O banco de dados está acessível".colorize(:yellow)
    
rescue => e
    puts "\n Erro inesperado:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
end
