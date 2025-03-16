require 'colorize'

begin
    puts "\n Iniciando associações entre Perfis e Permissões...".colorize(:blue)

    # Estatísticas de processamento
    stats = { criadas: 0, erros: 0, perfis_processados: 0 }

    # Definição do mapeamento de permissões
    perfil_permissions_map = {
        "Super Admin" => Permission.all.pluck(:name), # Todas as permissões

        "Analista De Dados" => [
            "Visualizar métricas",
            "Exportar métricas",
            "Filtrar métricas",
            "Listar vendas",
            "Visualizar venda",
            "Listar finanças",
            "Visualizar finança"
        ],

        "Gerente Comercial" => [
            "Listar vendas",
            "Visualizar venda",
            "Criar venda",
            "Atualizar venda",
            "Visualizar métricas",
            "Exportar métricas",
            "Filtrar métricas"
        ],

        "Diretor Executivo" => [
            "Visualizar métricas",
            "Exportar métricas",
            "Filtrar métricas",
            "Listar vendas",
            "Visualizar venda",
            "Listar finanças",
            "Visualizar finança",
            "Exportar finanças",
            "Visualizar configurações"
        ],

        "Digitador" => [  # Alterado de "Operador" para "Digitador"
            "Listar vendas",
            "Visualizar venda",
            "Criar venda"
        ],

        "Gerente De Marketing" => [  # Alterado de "Marketing" para "Gerente De Marketing"
            "Criar demanda",
            "Listar demandas",
            "Visualizar demanda",
            "Atualizar demanda",
            "Visualizar métricas",
            "Filtrar métricas"
        ],

        "Supervisor" => [
            "Listar usuários",
            "Visualizar usuário",
            "Listar vendas",
            "Visualizar venda",
            "Atualizar venda",
            "Visualizar métricas",
            "Filtrar métricas"
        ],

        "Monitor De Fraudes" => [  # Ajustado para corresponder ao formato do titleize
            "Listar vendas",
            "Visualizar venda",
            "Listar finanças",
            "Visualizar finança",
            "Visualizar métricas",
            "Filtrar métricas"
        ]
    }

    # Processamento das associações
    perfil_permissions_map.each do |perfil_name, permission_names|
        begin
            perfil = Perfil.find_by(name: perfil_name)
            
            if perfil.nil?
                puts " Erro: Perfil '#{perfil_name}' não encontrado".colorize(:red)
                stats[:erros] += 1
                next
            end

            puts "\n⚪ Processando perfil: #{perfil_name}".colorize(:white)
            
            permission_names.each do |permission_name|
                begin
                    permission = Permission.find_by(name: permission_name)
                    
                    if permission.nil?
                        puts "🟡 Aviso: Permissão '#{permission_name}' não encontrada".colorize(:yellow)
                        stats[:erros] += 1
                        next
                    end

                    PerfilPermission.create!(
                        perfil: perfil,
                        permission: permission
                    )
                    
                    puts "🟢 Associação criada: #{perfil_name} -> #{permission_name}".colorize(:green)
                    stats[:criadas] += 1
                    
                rescue ActiveRecord::RecordInvalid => e
                    puts " Erro de validação: #{e.message}".colorize(:red)
                    stats[:erros] += 1
                rescue => e
                    puts " Erro ao criar associação: #{e.message}".colorize(:red)
                    puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
                    stats[:erros] += 1
                end
            end
            
            stats[:perfis_processados] += 1
            
        rescue => e
            puts " Erro ao processar perfil #{perfil_name}: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
            stats[:erros] += 1
        end
    end

    # Exibição do resumo da operação
    puts "\n Resumo da operação:".colorize(:cyan)
    puts " → Total de perfis processados: #{stats[:perfis_processados]}".colorize(:blue)
    puts "🟢 → Associações criadas com sucesso: #{stats[:criadas]}".colorize(:green)
    puts " → Erros encontrados: #{stats[:erros]}".colorize(:red)
    puts "⚫ → Total de associações no sistema: #{PerfilPermission.count}".colorize(:light_black)

rescue ActiveRecord::StatementInvalid => e
    puts "\n Erro de banco de dados:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟡 Verifique:".colorize(:yellow)
    puts "    1. As tabelas necessárias existem".colorize(:yellow)
    puts "    2. Todas as migrations foram executadas".colorize(:yellow)
    puts "    3. O banco de dados está acessível".colorize(:yellow)
    
rescue => e
    puts "\n Erro inesperado:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
end
