require 'colorize'

begin
    puts "\n Iniciando criação de perfis...".colorize(:blue)

    # Estatísticas de processamento
    stats = { criados: 0, existentes: 0, erros: 0 }

    # Definição dos perfis
    perfis = [
        'Super Admin',
        'Analista de Dados',
        'Gerente Comercial',
        'Gerente Executivo',
        'Diretor Executivo',
        'Digitador',
        'Gerente de Marketing',
        'Gerente de Estrategia',
        'Supervisor',
        'Monitor de Fraudes',
        'Gestor de CRM'
    ].freeze

    # Processamento dos perfis
    perfis.each do |nome|
        if nome.blank? || nome.length < 3
            puts "🟡 Perfil inválido: '#{nome}' (mínimo 3 caracteres)".colorize(:yellow)
            stats[:erros] += 1
            next
        end

        begin
            nome_normalizado = nome.strip.titleize
            perfil = Perfil.find_or_initialize_by(name: nome_normalizado)
            
            if perfil.new_record?
                if perfil.save
                    puts "🟢 Perfil criado: #{nome_normalizado}".colorize(:green)
                    stats[:criados] += 1
                else
                    puts " Erro ao criar perfil '#{nome_normalizado}': #{perfil.errors.full_messages.join(', ')}".colorize(:red)
                    stats[:erros] += 1
                end
            else
                puts "⚪ Perfil já existe: #{nome_normalizado}".colorize(:white)
                stats[:existentes] += 1
            end
        rescue => e
            puts " Erro ao processar perfil '#{nome_normalizado}': #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
            stats[:erros] += 1
        end
    end

    # Exibição do resumo da operação
    puts "\n Resumo da operação:".colorize(:cyan)
    puts " → Total de perfis processados: #{perfis.size}".colorize(:blue)
    puts "🟢 → Perfis criados: #{stats[:criados]}".colorize(:green)
    puts "⚪ → Perfis existentes: #{stats[:existentes]}".colorize(:white)
    puts " → Erros encontrados: #{stats[:erros]}".colorize(:red)
    puts "⚫ → Total de perfis no sistema: #{Perfil.count}".colorize(:light_black)

rescue ActiveRecord::StatementInvalid => e
    puts "\n Erro de banco de dados:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟡 Verifique:".colorize(:yellow)
    puts "    1. A tabela 'perfis' existe".colorize(:yellow)
    puts "    2. Todas as migrations foram executadas".colorize(:yellow)
    puts "    3. O banco de dados está acessível".colorize(:yellow)
    
rescue NameError => e
    puts "\n Erro de definição de classe:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟡 Verifique:".colorize(:yellow)
    puts "    1. O modelo Perfil está definido em #app/models/perfil.rb".colorize(:yellow)
    puts "    2. O nome da classe está correto (Perfil)".colorize(:yellow)
    puts "    3. O arquivo do modelo está no local correto".colorize(:yellow)
    
rescue => e
    puts "\n Erro inesperado:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟣 Stack trace:".colorize(:magenta)
    puts e.backtrace[0..5].map { |line| "    #{line}" }.join("\n").colorize(:magenta)
end