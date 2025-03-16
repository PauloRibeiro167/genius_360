require 'colorize'

begin
    puts "\n Iniciando criação de equipes...".colorize(:blue)

    # Estatísticas de processamento
    stats = { criadas: 0, existentes: 0, erros: 0 }

    # Função para normalizar strings
    def normalizar_string(str)
        return nil if str.nil?
        str.strip
           .gsub(/\s+/, ' ')           # Remove espaços múltiplos
           .gsub(/[áàãâä]/, 'a')       # Normaliza 'a'
           .gsub(/[éèêë]/, 'e')        # Normaliza 'e'
           .gsub(/[íìîï]/, 'i')        # Normaliza 'i'
           .gsub(/[óòõôö]/, 'o')       # Normaliza 'o'
           .gsub(/[úùûü]/, 'u')        # Normaliza 'u'
           .gsub(/[ç]/, 'c')           # Normaliza 'c'
           .gsub(/[^a-zA-Z0-9\s-]/, '') # Remove caracteres especiais
    end

    # Função para normalizar dados da equipe
    def normalizar_dados_equipe(equipe_attrs)
        {
            nome: normalizar_string(equipe_attrs[:nome]),
            descricao: normalizar_string(equipe_attrs[:descricao]),
            tipo_equipe: normalizar_string(equipe_attrs[:tipo_equipe]),
            regiao_atuacao: normalizar_string(equipe_attrs[:regiao_atuacao])
        }
    end

    puts " Iniciando normalização dos dados...".colorize(:cyan)

    # Verifica se existem usuários no sistema
    usuarios = User.all
    if usuarios.empty?
        puts "\n🟡 ATENÇÃO: Não existem usuários cadastrados.".colorize(:yellow)
        puts "🟡 Execute primeiro a seed de usuários (#db/seeds/create_users.rb)".colorize(:yellow)
        puts "⚪ Criando equipes sem líderes definidos...".colorize(:white)
    end

    # Tipos possíveis de equipes
    tipos_equipe = [
        "Vendas", "Atendimento", "Financeiro", 
        "Administrativo", "Operacional"
    ]

    # Regiões de atuação
    regioes = [
        "Norte", "Nordeste", "Centro-Oeste", 
        "Sudeste", "Sul", "Nacional"
    ]

    # Dados das equipes
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

    # Processamento das equipes com normalização
    equipes.each_with_index do |equipe_attrs, index|
        begin
            # Normaliza os dados antes de processar
            dados_normalizados = normalizar_dados_equipe(equipe_attrs)
            
            # Seleciona um usuário como líder
            lider = usuarios[index % usuarios.count] if usuarios.present?
            
            equipe = Equipe.find_or_initialize_by(nome: dados_normalizados[:nome])
            
            if equipe.new_record?
                if equipe.update(
                    descricao: dados_normalizados[:descricao],
                    lider: lider,
                    tipo_equipe: dados_normalizados[:tipo_equipe],
                    regiao_atuacao: dados_normalizados[:regiao_atuacao],
                    ativo: true
                )
                    puts "🟢 Equipe criada: #{equipe.nome} (#{equipe.tipo_equipe} - #{equipe.regiao_atuacao})".colorize(:green)
                    stats[:criadas] += 1
                else
                    puts " Erro ao criar equipe '#{equipe.nome}': #{equipe.errors.full_messages.join(', ')}".colorize(:red)
                    stats[:erros] += 1
                end
            else
                puts "⚪ Equipe já existe: #{equipe.nome}".colorize(:white)
                stats[:existentes] += 1
            end
        rescue => e
            puts " Erro ao processar equipe '#{equipe_attrs[:nome]}': #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
            stats[:erros] += 1
        end
    end

    # Criação de equipe inativa para demonstração
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
            puts "⚫ Equipe inativa criada: #{equipe_inativa.nome} [INATIVA]".colorize(:light_black)
            stats[:criadas] += 1
        rescue => e
            puts " Erro ao criar equipe inativa: #{e.message}".colorize(:red)
            stats[:erros] += 1
        end
    end

    # Exibição do resumo da operação
    puts "\n Resumo da operação:".colorize(:cyan)
    puts " → Total de equipes processadas: #{equipes.size + 1}".colorize(:blue)
    puts "🟢 → Equipes criadas: #{stats[:criadas]}".colorize(:green)
    puts "⚪ → Equipes existentes: #{stats[:existentes]}".colorize(:white)
    puts " → Erros encontrados: #{stats[:erros]}".colorize(:red)
    puts "⚫ → Total de equipes no sistema: #{Equipe.count}".colorize(:light_black)

rescue ActiveRecord::StatementInvalid => e
    puts "\n Erro de banco de dados:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟡 Verifique:".colorize(:yellow)
    puts "    1. A tabela 'equipes' existe".colorize(:yellow)
    puts "    2. Todas as migrations foram executadas".colorize(:yellow)
    puts "    3. O banco de dados está acessível".colorize(:yellow)
    
rescue NameError => e
    puts "\n Erro de definição de classe:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟡 Verifique:".colorize(:yellow)
    puts "    1. O modelo Equipe está definido em #app/models/equipe.rb".colorize(:yellow)
    puts "    2. O nome da classe está correto (Equipe)".colorize(:yellow)
    puts "    3. O arquivo do modelo está no local correto".colorize(:yellow)
    
rescue => e
    puts "\n Erro inesperado:".colorize(:red)
    puts " → #{e.message}".colorize(:red)
    puts "\n🟣 Stack trace:".colorize(:magenta)
    puts e.backtrace[0..5].map { |line| "    #{line}" }.join("\n").colorize(:magenta)
end