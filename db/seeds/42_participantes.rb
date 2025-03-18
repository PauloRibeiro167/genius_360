sucessos = 0
erros = 0

begin
    reunioes = Reuniao.all
    users = User.all

    puts "Encontradas #{reunioes.count} reuniões e #{users.count} usuários"

    if reunioes.any? && users.any?
        participantes_data = [
            {
                reuniao: reunioes.first,
                user: users.first,
                status: 'confirmado',
                observacoes: 'Participante confirmou presença'
            },
            {
                reuniao: reunioes.first,
                user: users.second,
                status: 'pendente',
                observacoes: 'Aguardando confirmação'
            },
            {
                reuniao: reunioes.last,
                user: users.first,
                status: 'recusado',
                observacoes: 'Indisponível na data'
            }
        ]

        participantes_data.each do |participante_data|
            begin
                puts "Processando participante: #{participante_data[:user].email}"
                
                Participante.find_or_create_by!(
                    reuniao: participante_data[:reuniao],
                    user: participante_data[:user]
                ) do |participante|
                    participante.status = participante_data[:status].to_s.downcase.strip
                    participante.observacoes = participante_data[:observacoes].to_s.strip
                end
                
                sucessos += 1
                puts "Participante processado com sucesso"
            rescue => e
                erros += 1
                puts "Erro ao processar participante: #{e.message}"
            end
        end

        puts "\n=== Resumo da Operação ==="
        puts "Participantes criados com sucesso: #{sucessos}"
        puts "Erros encontrados: #{erros}" if erros > 0
        puts "Total processado: #{sucessos + erros}"
    else
        puts "Aviso: Não existem reuniões ou usuários cadastrados no sistema"
    end
rescue => e
    puts "Erro fatal: #{e.message}"
    puts "Debug: #{e.backtrace.first}"
end
