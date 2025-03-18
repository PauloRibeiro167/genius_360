puts "\n Iniciando criação de disponibilidades..."

disponibilidades_criadas = 0
disponibilidades_com_erro = 0
total_processado = 0

dias_semana = %w[segunda-feira terca-feira quarta-feira quinta-feira sexta-feira]

puts " Buscando usuários cadastrados..."
users = User.all
puts "Total de usuários encontrados: #{users.count}"

users.each do |user|
    puts "\nProcessando disponibilidades para: #{user.email}"
    
    dias_semana.each do |dia|
        begin
            hora_inicio = rand(8..15)
            duracao = rand(2..4)
            hora_fim = hora_inicio + duracao
            
            disponibilidade = Disponibilidade.new(
                user: user,
                dia_semana: dia,
                hora_inicio: Time.current.change(hour: hora_inicio, min: 0),
                hora_fim: Time.current.change(hour: hora_fim, min: 0),
                disponivel: [true, true, true, false].sample
            )

            if disponibilidade.save
                disponibilidades_criadas += 1
                puts "Disponibilidade criada: #{dia} (#{hora_inicio}h - #{hora_fim}h)"
            else
                disponibilidades_com_erro += 1
                puts "Erro ao criar disponibilidade: #{disponibilidade.errors.full_messages.join(', ')}"
            end
            
        rescue => e
            disponibilidades_com_erro += 1
            puts "Erro inesperado: #{e.message}"
        end
        
        total_processado += 1
    end
end

puts "\n=== Resumo da Operação ==="
puts "Total de registros processados: #{total_processado}"
puts "Disponibilidades criadas com sucesso: #{disponibilidades_criadas}"
puts "Disponibilidades com erro: #{disponibilidades_com_erro}"
puts "Taxa de sucesso: #{((disponibilidades_criadas.to_f / total_processado) * 100).round(2)}%"
puts "=========================================="

if disponibilidades_com_erro > 0
    puts "\nAtenção: Houve erros durante o processo. Verifique o log acima."
else
    puts "\nProcesso concluído com sucesso!"
end
