begin
    puts "\n Iniciando criação de equipes..."

    stats = { criadas: 0, existentes: 0, erros: 0 }

    usuarios = User.all
    if usuarios.empty?
        puts "\n Não existem usuários cadastrados."
        puts " Execute primeiro a seed de usuários"
        puts " Criando equipes sem líderes definidos..."
    end

    equipes = [
        {
            nome: "Equipe Alfa",
            descricao: "Equipe principal de vendas para região Sudeste",
            tipo_equipe: "Vendas",
            regiao_atuacao: "Sudeste"
        },
        {
            nome: "Equipe Beta",
            descricao: "Equipe de vendas focada na região Sul",
            tipo_equipe: "Vendas",
            regiao_atuacao: "Sul"
        },
        {
            nome: "Equipe Gama",
            descricao: "Equipe de atendimento ao cliente",
            tipo_equipe: "Atendimento",
            regiao_atuacao: "Nacional"
        },
        {
            nome: "Equipe Operações Norte",
            descricao: "Equipe operacional para a região Norte",
            tipo_equipe: "Operacional",
            regiao_atuacao: "Norte"
        },
        {
            nome: "Equipe Financeira",
            descricao: "Equipe responsável pelo financeiro da empresa",
            tipo_equipe: "Financeiro",
            regiao_atuacao: "Nacional"
        },
        {
            nome: "Equipe Administrativa",
            descricao: "Equipe de suporte administrativo",
            tipo_equipe: "Administrativo",
            regiao_atuacao: "Nacional"
        },
        {
            nome: "Equipe Nordeste",
            descricao: "Equipe de vendas focada na região Nordeste",
            tipo_equipe: "Vendas",
            regiao_atuacao: "Nordeste"
        },
        {
            nome: "Equipe Centro-Oeste",
            descricao: "Equipe de vendas focada na região Centro-Oeste",
            tipo_equipe: "Vendas",
            regiao_atuacao: "Centro-Oeste"
        }
    ]

    equipes.each_with_index do |equipe_attrs, index|
        begin
            lider = usuarios[index % usuarios.count] if usuarios.present?
            
            equipe = Equipe.find_or_initialize_by(nome: equipe_attrs[:nome])
            
            if equipe.new_record?
                if equipe.update(
                    descricao: equipe_attrs[:descricao],
                    lider: lider,
                    tipo_equipe: equipe_attrs[:tipo_equipe],
                    regiao_atuacao: equipe_attrs[:regiao_atuacao],
                    ativo: true
                )
                    puts "Equipe criada: #{equipe.nome}"
                    stats[:criadas] += 1
                else
                    puts "Erro ao criar equipe '#{equipe.nome}': #{equipe.errors.full_messages.join(', ')}"
                    stats[:erros] += 1
                end
            else
                puts "Equipe já existe: #{equipe.nome}"
                stats[:existentes] += 1
            end
        rescue => e
            puts "Erro ao processar equipe '#{equipe_attrs[:nome]}': #{e.message}"
            stats[:erros] += 1
        end
    end

    if usuarios.present?
        begin
            equipe_inativa = Equipe.create!(
                nome: "Equipe Legado",
                descricao: "Equipe descontinuada após reestruturação",
                lider: usuarios.last,
                tipo_equipe: "Vendas",
                regiao_atuacao: "Nacional",
                ativo: false,
                discarded_at: 3.months.ago
            )
            puts "Equipe inativa criada: #{equipe_inativa.nome}"
            stats[:criadas] += 1
        rescue => e
            puts "Erro ao criar equipe inativa: #{e.message}"
            stats[:erros] += 1
        end
    end

    puts "\nResumo da operação:"
    puts "Total de equipes processadas: #{equipes.size + 1}"
    puts "Equipes criadas: #{stats[:criadas]}"
    puts "Equipes existentes: #{stats[:existentes]}"
    puts "Erros encontrados: #{stats[:erros]}"
    puts "Total de equipes no sistema: #{Equipe.count}"

rescue ActiveRecord::StatementInvalid => e
    puts "\nErro de banco de dados: #{e.message}"
rescue NameError => e
    puts "\nErro de definição de classe: #{e.message}"
rescue => e
    puts "\nErro inesperado: #{e.message}"
end
