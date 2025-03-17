require 'colorize'

# Contadores para estatísticas
sucessos = 0
erros = 0

puts " Iniciando criação de participantes...".colorize(:blue)

# Função de normalização
def normalizar_dados(participante_data)
    {
        reuniao: participante_data[:reuniao],
        user: participante_data[:user],
        status: participante_data[:status].to_s.downcase.strip,
        observacoes: participante_data[:observacoes].to_s.strip
    }
end

begin
    # Verifica pré-requisitos
    reunioes = Reuniao.all
    users = User.all

    puts "🟣 Debug: Encontradas #{reunioes.count} reuniões e #{users.count} usuários".colorize(:magenta)

    if reunioes.any? && users.any?
        # Dados de exemplo
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

        # Processamento dos participantes
        participantes_data.each do |participante_data|
            begin
                dados_normalizados = normalizar_dados(participante_data)
                puts " Processando participante: #{dados_normalizados[:user].email}".colorize(:cyan)
                
                Participante.find_or_create_by!(
                    reuniao: dados_normalizados[:reuniao],
                    user: dados_normalizados[:user]
                ) do |participante|
                    participante.status = dados_normalizados[:status]
                    participante.observacoes = dados_normalizados[:observacoes]
                end
                
                sucessos += 1
                puts "⚪ Participante processado com sucesso".colorize(:white)
            rescue => e
                erros += 1
                puts " Erro ao processar participante: #{e.message}".colorize(:red)
            end
        end

        # Exibição do resumo
        puts "\n=== Resumo da Operação ===".colorize(:blue)
        puts "🟢 Participantes criados com sucesso: #{sucessos}".colorize(:green)
        puts " Erros encontrados: #{erros}".colorize(:red) if erros > 0
        puts "⚫ Total processado: #{sucessos + erros}".colorize(:light_black)
    else
        puts "🟡 Aviso: Não existem reuniões ou usuários cadastrados no sistema".colorize(:yellow)
    end
rescue => e
    puts " Erro fatal: #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
end