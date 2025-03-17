require 'colorize'

def normalizar_nome(texto)
    return nil if texto.nil?
    texto.strip
         .gsub(/[áàãâä]/, 'a')
         .gsub(/[éèêë]/, 'e')
         .gsub(/[íìîï]/, 'i')
         .gsub(/[óòõôö]/, 'o')
         .gsub(/[úùûü]/, 'u')
         .gsub(/[ç]/, 'c')
         .gsub(/[ÁÀÃÂÄ]/, 'A')
         .gsub(/[ÉÈÊË]/, 'E')
         .gsub(/[ÍÌÎÏ]/, 'I')
         .gsub(/[ÓÒÕÔÖ]/, 'O')
         .gsub(/[ÚÙÛÜ]/, 'U')
         .gsub(/[Ç]/, 'C')
         .gsub(/[^0-9A-Za-z\s]/, '')
         .upcase
end

# Inicialização de contadores
total_sucessos = 0
total_erros = 0

puts " Iniciando verificação do ambiente...".colorize(:blue)

begin
    # Verifica se a tabela existe
    unless ActiveRecord::Base.connection.table_exists?('equipes_users')  # Nome corrigido
        puts " ERRO: Tabela 'equipes_users' não existe. Execute as migrações primeiro.".colorize(:red)
        puts "🟡 DICA: Execute 'rails db:migrate' para criar a tabela".colorize(:yellow)
        exit
    end

    puts " Verificando dependências...".colorize(:blue)

    # Verifica se existem usuários e equipes no sistema
    usuarios = User.all
    equipes = Equipe.all

    if usuarios.empty?
        puts " ERRO: Não existem usuários cadastrados. Execute primeiro #30_users.rb".colorize(:red)
        exit
    end

    if equipes.empty?
        puts " ERRO: Não existem equipes cadastradas. Execute primeiro #31_equipes.rb".colorize(:red)
        exit
    end

    puts "🟢 Ambiente verificado com sucesso".colorize(:green)
    puts " Iniciando associação de usuários às equipes...".colorize(:blue)

    # Cargos possíveis nas equipes
    cargos = [
      "Vendedor", 
      "Supervisor", 
      "Gerente", 
      "Analista", 
      "Assistente", 
      "Coordenador", 
      "Consultor"
    ]

    # Data atual para referência
    data_atual = Date.today

    # Contador de associações
    associacoes_criadas = 0

    # Distribui usuários entre as equipes
    # Cada usuário pode estar em 1 ou 2 equipes
    usuarios.each do |usuario|
        begin
            # Quantidade de equipes que o usuário participa (1 ou 2, com maior probabilidade de 1)
            quantidade_equipes = rand < 0.3 ? 2 : 1
            
            # Seleciona equipes aleatórias para o usuário
            equipes_do_usuario = equipes.where(ativo: true).sample(quantidade_equipes)
            
            # Modifique o bloco que cria a associação
            equipes_do_usuario.each do |equipe|
                begin
                    # Verifica se o usuário já está nesta equipe
                    if EquipeUser.exists?(equipe: equipe, user: usuario)
                        puts "⚠️  #{usuario.email} já está associado à equipe #{equipe.nome}".colorize(:yellow)
                        next
                    end

                    # Para líderes de equipe, atribuir cargo de Gerente ou Supervisor
                    if equipe.lider_id == usuario.id
                        cargo = ["Gerente", "Supervisor"].sample
                    else
                        cargo = cargos.sample
                    end
                    
                    # Data de entrada (entre 1 ano atrás e hoje)
                    data_entrada = rand(365).days.ago
                    
                    # Data de saída (nil para membros ativos, data no passado para inativos)
                    data_saida = rand < 0.9 ? nil : rand(30..90).days.ago
                    
                    # Define se o membro está ativo
                    ativo = data_saida.nil?
                    
                    # Meta individual (valor entre 10.000 e 50.000)
                    meta_individual = rand(10000..50000)
                    
                    # Cria a associação diretamente com create!
                    associacao = EquipeUser.create!(
                        equipe_id: equipe.id,
                        user_id: usuario.id,
                        cargo: cargo,
                        data_entrada: data_entrada,
                        data_saida: data_saida,
                        ativo: ativo,
                        meta_individual: meta_individual,
                        discarded_at: data_saida
                    )
                    
                    associacoes_criadas += 1
                    status = ativo ? "[ATIVO]" : "[INATIVO]"
                    puts "#{usuario.email} associado à equipe #{equipe.nome} como #{cargo} #{status}"
                    
                rescue ActiveRecord::RecordInvalid => e
                    puts " Erro ao associar #{usuario.email} à equipe #{equipe.nome}: #{e.message}".colorize(:red)
                end
            end
            total_sucessos += 1
            puts "🟢 #{usuario.email} processado com sucesso".colorize(:green)
        rescue => e
            total_erros += 1
            puts " Erro ao processar usuário #{usuario.email}: #{e.message}".colorize(:red)
        end
    end

    # Modifique apenas a parte final do arquivo, onde criamos as associações específicas:
    if equipes.where(ativo: true).count >= 2 && usuarios.count >= 5
        # Seleciona duas equipes ativas
        equipe_vendas = equipes.find_by(tipo_equipe: "Vendas", ativo: true)
        equipe_adm = equipes.find_by(tipo_equipe: "Administrativo", ativo: true)
        
        if equipe_vendas && equipe_adm
            # Seleciona alguns usuários para fazer parte de ambas as equipes
            usuarios_multi_equipe = usuarios.sample(2)
            
            usuarios_multi_equipe.each do |usuario|
                begin
                    # Tenta associar à equipe de vendas se ainda não estiver associado
                    unless EquipeUser.exists?(equipe: equipe_vendas, user: usuario)
                        EquipeUser.create!(
                            equipe_id: equipe_vendas.id,
                            user_id: usuario.id,
                            cargo: "Vendedor",
                            data_entrada: 6.months.ago,
                            ativo: true,
                            meta_individual: 40000
                        )
                        puts "#{usuario.email} associado à equipe #{equipe_vendas.nome} como Vendedor [ATIVO]"
                    end
                    
                    # Tenta associar à equipe administrativa se ainda não estiver associado
                    unless EquipeUser.exists?(equipe: equipe_adm, user: usuario)
                        EquipeUser.create!(
                            equipe_id: equipe_adm.id,
                            user_id: usuario.id,
                            cargo: "Assistente",
                            data_entrada: 3.months.ago,
                            ativo: true,
                            meta_individual: 20000
                        )
                        puts "#{usuario.email} associado à equipe #{equipe_adm.nome} como Assistente [ATIVO]"
                    end
                    
                    associacoes_criadas += 2
                rescue ActiveRecord::RecordInvalid => e
                    puts " Erro ao criar associação múltipla: #{e.message}".colorize(:red)
                end
            end
        end
    end

rescue => e
    puts " ERRO FATAL: #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
    exit
end

# Resumo final atualizado
puts "\n⚪ Resumo da Operação".colorize(:white)
puts "🟢 Total de sucessos: #{total_sucessos}".colorize(:green)
puts " Total de erros: #{total_erros}".colorize(:red)
puts "🟡 Total de usuários processados: #{usuarios.count}".colorize(:yellow)
puts "⚫ Total de equipes envolvidas: #{equipes.count}".colorize(:light_black)

if total_erros.zero?
    puts "🟢 Processo finalizado com sucesso!".colorize(:green)
else
    puts " Processo finalizado com alertas!".colorize(:red)
    puts "🟡 Verifique os logs para mais detalhes".colorize(:yellow)
end