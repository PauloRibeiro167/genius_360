begin
    puts "\n Iniciando associações entre Perfis e Permissões..."

    stats = { criadas: 0, erros: 0, perfis_processados: 0 }

    perfil_permissions_map = {
        "Super Admin" => Permission.all.pluck(:name),

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

        "Digitador" => [
            "Listar vendas",
            "Visualizar venda",
            "Criar venda"
        ],

        "Gerente De Marketing" => [
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

        "Monitor De Fraudes" => [
            "Listar vendas",
            "Visualizar venda",
            "Listar finanças",
            "Visualizar finança",
            "Visualizar métricas",
            "Filtrar métricas"
        ]
    }

    perfil_permissions_map.each do |perfil_name, permission_names|
        begin
            perfil = Perfil.find_by(name: perfil_name)
            
            if perfil.nil?
                puts "Erro: Perfil '#{perfil_name}' não encontrado"
                stats[:erros] += 1
                next
            end

            puts "\nProcessando perfil: #{perfil_name}"
            
            permission_names.each do |permission_name|
                begin
                    permission = Permission.find_by(name: permission_name)
                    
                    if permission.nil?
                        puts "Aviso: Permissão '#{permission_name}' não encontrada"
                        stats[:erros] += 1
                        next
                    end

                    PerfilPermission.create!(
                        perfil: perfil,
                        permission: permission
                    )
                    
                    puts "Associação criada: #{perfil_name} -> #{permission_name}"
                    stats[:criadas] += 1
                    
                rescue ActiveRecord::RecordInvalid => e
                    puts "Erro de validação: #{e.message}"
                    stats[:erros] += 1
                rescue => e
                    puts "Erro ao criar associação: #{e.message}"
                    stats[:erros] += 1
                end
            end
            
            stats[:perfis_processados] += 1
            
        rescue => e
            puts "Erro ao processar perfil #{perfil_name}: #{e.message}"
            stats[:erros] += 1
        end
    end

    puts "\nResumo da operação:"
    puts "Total de perfis processados: #{stats[:perfis_processados]}"
    puts "Associações criadas com sucesso: #{stats[:criadas]}"
    puts "Erros encontrados: #{stats[:erros]}"
    puts "Total de associações no sistema: #{PerfilPermission.count}"

rescue ActiveRecord::StatementInvalid => e
    puts "\nErro de banco de dados:"
    puts "#{e.message}"
    
rescue => e
    puts "\nErro inesperado:"
    puts "#{e.message}"
end
