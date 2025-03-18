require 'colorize'

begin
    puts "\n Iniciando criação de hierarquias..."

    stats = { criadas: 0, existentes: 0, erros: 0 }

    hierarquias = [
        { nome: "Diretoria", nivel: 1, descricao: "Nível executivo" },
        { nome: "Gerência", nivel: 2, descricao: "Nível gerencial" },
        { nome: "Coordenação", nivel: 3, descricao: "Nível de coordenação" },
        { nome: "Operacional", nivel: 4, descricao: "Nível operacional" }
    ]

    hierarquias.each do |h|
        begin
            hierarquia = Hierarquia.find_or_initialize_by(nome: h[:nome])
            
            if hierarquia.new_record?
                if hierarquia.update(h)
                    puts "Hierarquia criada: #{h[:nome]}"
                    stats[:criadas] += 1
                else
                    puts "Erro ao criar hierarquia '#{h[:nome]}': #{hierarquia.errors.full_messages.join(', ')}"
                    stats[:erros] += 1
                end
            else
                puts "Hierarquia já existe: #{h[:nome]}"
                stats[:existentes] += 1
            end
            
        rescue ActiveRecord::RecordInvalid => e
            puts "Erro de validação ao criar hierarquia '#{h[:nome]}': #{e.message}"
            stats[:erros] += 1
        rescue => e
            puts "Erro inesperado ao criar hierarquia '#{h[:nome]}': #{e.message}"
            puts "Debug: #{e.backtrace[0..2].map(&:to_s).join("\n")}"
            stats[:erros] += 1
        end
    end

    puts "\nResumo da operação:"
    puts "Total de hierarquias processadas: #{hierarquias.size}"
    puts "Hierarquias criadas: #{stats[:criadas]}"
    puts "Hierarquias existentes: #{stats[:existentes]}"
    puts "Erros encontrados: #{stats[:erros]}"
    puts "Total de hierarquias no sistema: #{Hierarquia.count}"

rescue ActiveRecord::StatementInvalid => e
    puts "\nErro de banco de dados:"
    puts "#{e.message}"
    puts "\nVerifique:"
    puts "1. A tabela 'hierarquias' existe"
    puts "2. Todas as migrations foram executadas"
    puts "3. O banco de dados está acessível"
    
rescue NameError => e
    puts "\nErro de definição de classe:"
    puts "#{e.message}"
    puts "\nVerifique:"
    puts "1. O modelo Hierarquia está definido em app/models/hierarquia.rb"
    puts "2. O nome da classe está correto (Hierarquia)"
    puts "3. O arquivo do modelo está no local correto"
    
rescue => e
    puts "\nErro inesperado:"
    puts "#{e.message}"
    puts "\nStack trace:"
    puts e.backtrace[0..5].map { |line| "#{line}" }.join("\n")
end
