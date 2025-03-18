begin
    puts "\n Iniciando criação de perfis..."

    stats = { criados: 0, existentes: 0, erros: 0 }

    perfis = [
        'Super Admin',
        'Gerente de Marketing',
        'Gerente de Estrategia',
        'Gerente Comercial',
        'Gerente Executivo',
        'Gestor de CRM',
        'Gestor de Projetos',
        'Analista de Dados',
        'Diretor Executivo',
        'Digitador',
        'Supervisor',
        'Monitor de Fraudes',
    ].freeze

    perfis.each do |nome|
        if nome.blank? || nome.length < 3
            puts "Perfil inválido: '#{nome}' (mínimo 3 caracteres)"
            stats[:erros] += 1
            next
        end

        begin
            nome_normalizado = nome.strip.titleize
            perfil = Perfil.find_or_initialize_by(name: nome_normalizado)
            
            if perfil.new_record?
                if perfil.save
                    puts "Perfil criado: #{nome_normalizado}"
                    stats[:criados] += 1
                else
                    puts "Erro ao criar perfil '#{nome_normalizado}': #{perfil.errors.full_messages.join(', ')}"
                    stats[:erros] += 1
                end
            else
                puts "Perfil já existe: #{nome_normalizado}"
                stats[:existentes] += 1
            end
        rescue => e
            puts "Erro ao processar perfil '#{nome_normalizado}': #{e.message}"
            puts "Debug: #{e.backtrace[0..2].join("\n")}"
            stats[:erros] += 1
        end
    end

    puts "\nResumo da operação:"
    puts "Total de perfis processados: #{perfis.size}"
    puts "Perfis criados: #{stats[:criados]}"
    puts "Perfis existentes: #{stats[:existentes]}"
    puts "Erros encontrados: #{stats[:erros]}"
    puts "Total de perfis no sistema: #{Perfil.count}"

rescue ActiveRecord::StatementInvalid => e
    puts "\nErro de banco de dados:"
    puts "#{e.message}"
    puts "\nVerifique:"
    puts "1. A tabela 'perfis' existe"
    puts "2. Todas as migrations foram executadas"
    puts "3. O banco de dados está acessível"
    
rescue NameError => e
    puts "\nErro de definição de classe:"
    puts "#{e.message}"
    puts "\nVerifique:"
    puts "1. O modelo Perfil está definido em app/models/perfil.rb"
    puts "2. O nome da classe está correto (Perfil)"
    puts "3. O arquivo do modelo está no local correto"
    
rescue => e
    puts "\nErro inesperado:"
    puts "#{e.message}"
    puts "\nStack trace:"
    puts e.backtrace[0..5].map { |line| "#{line}" }.join("\n")
end
