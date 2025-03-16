require 'colorize'

begin
    puts "\n Iniciando criação de Action Permissions...".colorize(:blue)

    # Estatísticas de processamento
    stats = { criadas: 0, existentes: 0, erros: 0 }

    # Definição das permissões de ação
    action_permissions = [
        # Ações do Controller
        { name: "index" },
        { name: "show" },
        { name: "create" },
        { name: "update" },
        { name: "destroy" },
        
        # Ações específicas
        { name: "export" },
        { name: "filter" },
        { name: "import" },
        { name: "approve" },
        { name: "reject" },
        { name: "cancel" },
        { name: "restore" }
    ]

    # Processamento das permissões
    action_permissions.each do |action|
        begin
            action_permission = ActionPermission.find_or_initialize_by(name: action[:name])
            
            if action_permission.new_record?
                if action_permission.save
                    puts "🟢 Action Permission criada: #{action[:name]}".colorize(:green)
                    stats[:criadas] += 1
                else
                    puts " Erro ao criar action permission '#{action[:name]}': #{action_permission.errors.full_messages.join(', ')}".colorize(:red)
                    stats[:erros] += 1
                end
            else
                puts "⚪ Action Permission já existe: #{action[:name]}".colorize(:white)
                stats[:existentes] += 1
            end
            
        rescue => e
            puts " Erro ao processar action permission '#{action[:name]}': #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
            stats[:erros] += 1
        end
    end

    # Exibição do resumo da operação
    puts "\n Resumo da operação:".colorize(:cyan)
    puts " → Total de actions processadas: #{action_permissions.size}".colorize(:blue)
    puts "🟢 → Actions criadas: #{stats[:criadas]}".colorize(:green)
    puts "⚪ → Actions existentes: #{stats[:existentes]}".colorize(:white)
    puts " → Erros encontrados: #{stats[:erros]}".colorize(:red)
    puts "⚫ → Total de actions no sistema: #{ActionPermission.count}".colorize(:light_black)

rescue => e
    puts "\n Erro inesperado:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟣 Stack trace:".colorize(:magenta)
    puts e.backtrace[0..5].map { |line| "    #{line}" }.join("\n").colorize(:magenta)
end