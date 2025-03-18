begin
    puts "\n Iniciando criação de Action Permissions..."

    stats = { criadas: 0, existentes: 0, erros: 0 }

    action_permissions = [
        { name: "index" },
        { name: "show" },
        { name: "create" },
        { name: "update" },
        { name: "destroy" },
        { name: "export" },
        { name: "filter" },
        { name: "import" },
        { name: "approve" },
        { name: "reject" },
        { name: "cancel" },
        { name: "restore" }
    ]

    action_permissions.each do |action|
        begin
            action_permission = ActionPermission.find_or_initialize_by(name: action[:name])
            
            if action_permission.new_record?
                if action_permission.save
                    puts "Action Permission criada: #{action[:name]}"
                    stats[:criadas] += 1
                else
                    puts "Erro ao criar action permission '#{action[:name]}': #{action_permission.errors.full_messages.join(', ')}"
                    stats[:erros] += 1
                end
            else
                puts "Action Permission já existe: #{action[:name]}"
                stats[:existentes] += 1
            end
            
        rescue => e
            puts "Erro ao processar action permission '#{action[:name]}': #{e.message}"
            puts "Debug: #{e.backtrace[0..2].join("\n")}"
            stats[:erros] += 1
        end
    end

    puts "\n Resumo da operação:"
    puts "Total de actions processadas: #{action_permissions.size}"
    puts "Actions criadas: #{stats[:criadas]}"
    puts "Actions existentes: #{stats[:existentes]}"
    puts "Erros encontrados: #{stats[:erros]}"
    puts "Total de actions no sistema: #{ActionPermission.count}"

rescue => e
    puts "\n Erro inesperado:"
    puts "#{e.message}"
    puts "\n Stack trace:"
    puts e.backtrace[0..5].map { |line| "#{line}" }.join("\n")
end
