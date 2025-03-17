puts "\n Iniciando criação de disponibilidades...".colorize(:blue)

# Função para normalizar strings
def normalize_string(str)
    str.strip
       .gsub(/[áàãâä]/, 'a')
       .gsub(/[éèêë]/, 'e')
       .gsub(/[íìîï]/, 'i')
       .gsub(/[óòõôö]/, 'o')
       .gsub(/[úùûü]/, 'u')
       .gsub(/[ç]/, 'c')
       .downcase
end

# Contadores para o relatório final
disponibilidades_criadas = 0
disponibilidades_com_erro = 0
total_processado = 0

# Array com os dias da semana (já normalizados)
dias_semana = %w[segunda-feira terca-feira quarta-feira quinta-feira sexta-feira]

puts " Buscando usuários cadastrados...".colorize(:cyan)
users = User.all
puts "⚪ Total de usuários encontrados: #{users.count}".colorize(:white)

# Para cada usuário, cria disponibilidades para os dias da semana
users.each do |user|
    puts "\n🟣 Processando disponibilidades para: #{user.email}".colorize(:magenta)
    
    dias_semana.each do |dia|
        begin
            # Define horários aleatórios (entre 8h e 18h)
            hora_inicio = rand(8..15)
            duracao = rand(2..4)
            hora_fim = hora_inicio + duracao
            
            disponibilidade = Disponibilidade.new(
                user: user,
                dia_semana: dia,
                hora_inicio: Time.current.change(hour: hora_inicio, min: 0),
                hora_fim: Time.current.change(hour: hora_fim, min: 0),
                disponivel: [true, true, true, false].sample # 75% de chance de estar disponível
            )

            if disponibilidade.save
                disponibilidades_criadas += 1
                puts "🟢 Disponibilidade criada: #{dia} (#{hora_inicio}h - #{hora_fim}h)".colorize(:green)
            else
                disponibilidades_com_erro += 1
                puts " Erro ao criar disponibilidade: #{disponibilidade.errors.full_messages.join(', ')}".colorize(:red)
            end
            
        rescue => e
            disponibilidades_com_erro += 1
            puts " Erro inesperado: #{e.message}".colorize(:red)
        end
        
        total_processado += 1
    end
end

# Exibe estatísticas e resumo
puts "\n=== Resumo da Operação ===".colorize(:white)
puts "⚪ Total de registros processados: #{total_processado}".colorize(:white)
puts "🟢 Disponibilidades criadas com sucesso: #{disponibilidades_criadas}".colorize(:green)
puts " Disponibilidades com erro: #{disponibilidades_com_erro}".colorize(:red)
puts "⚫ Taxa de sucesso: #{((disponibilidades_criadas.to_f / total_processado) * 100).round(2)}%".colorize(:light_black)
puts "==========================================".colorize(:white)

if disponibilidades_com_erro > 0
    puts "\n🟡 Atenção: Houve erros durante o processo. Verifique o log acima.".colorize(:yellow)
else
    puts "\n🟢 Processo concluído com sucesso!".colorize(:green)
end