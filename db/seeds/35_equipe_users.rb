total_sucessos = 0
total_erros = 0

begin
    unless ActiveRecord::Base.connection.table_exists?('equipes_users')
        puts "ERRO: Tabela 'equipes_users' não existe. Execute as migrações primeiro."
        puts "DICA: Execute 'rails db:migrate' para criar a tabela"
        exit
    end

    usuarios = User.all
    equipes = Equipe.all

    if usuarios.empty?
        puts "ERRO: Não existem usuários cadastrados. Execute primeiro #30_users.rb"
        exit
    end

    if equipes.empty?
        puts "ERRO: Não existem equipes cadastradas. Execute primeiro #31_equipes.rb"
        exit
    end

    cargos = ["Vendedor", "Supervisor", "Gerente", "Analista", "Assistente", "Coordenador", "Consultor"]
    data_atual = Date.today
    associacoes_criadas = 0

    usuarios.each do |usuario|
        begin
            quantidade_equipes = rand < 0.3 ? 2 : 1
            equipes_do_usuario = equipes.where(ativo: true).sample(quantidade_equipes)
            
            equipes_do_usuario.each do |equipe|
                begin
                    if EquipeUser.exists?(equipe: equipe, user: usuario)
                        puts "#{usuario.email} já está associado à equipe #{equipe.nome}"
                        next
                    end

                    cargo = equipe.lider_id == usuario.id ? ["Gerente", "Supervisor"].sample : cargos.sample
                    data_entrada = rand(365).days.ago
                    data_saida = rand < 0.9 ? nil : rand(30..90).days.ago
                    ativo = data_saida.nil?
                    meta_individual = rand(10000..50000)
                    
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
                    puts "Erro ao associar #{usuario.email} à equipe #{equipe.nome}: #{e.message}"
                end
            end
            total_sucessos += 1
            puts "#{usuario.email} processado com sucesso"
        rescue => e
            total_erros += 1
            puts "Erro ao processar usuário #{usuario.email}: #{e.message}"
        end
    end

    if equipes.where(ativo: true).count >= 2 && usuarios.count >= 5
        equipe_vendas = equipes.find_by(tipo_equipe: "Vendas", ativo: true)
        equipe_adm = equipes.find_by(tipo_equipe: "Administrativo", ativo: true)
        
        if equipe_vendas && equipe_adm
            usuarios_multi_equipe = usuarios.sample(2)
            
            usuarios_multi_equipe.each do |usuario|
                begin
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
                    puts "Erro ao criar associação múltipla: #{e.message}"
                end
            end
        end
    end

rescue => e
    puts "ERRO FATAL: #{e.message}"
    puts "Debug: #{e.backtrace.first}"
    exit
end

puts "\nResumo da Operação"
puts "Total de sucessos: #{total_sucessos}"
puts "Total de erros: #{total_erros}"
puts "Total de usuários processados: #{usuarios.count}"
puts "Total de equipes envolvidas: #{equipes.count}"

if total_erros.zero?
    puts "Processo finalizado com sucesso!"
else
    puts "Processo finalizado com alertas!"
    puts "Verifique os logs para mais detalhes"
end
