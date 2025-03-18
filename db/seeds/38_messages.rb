puts " Iniciando criação de mensagens para demonstração..."

mensagens_criadas = 0
total_sucesso = 0
total_erros = 0

users = User.all
if users.count < 2
  puts " ERRO: É necessário ter pelo menos 2 usuários cadastrados."
  puts "Execute primeiro a seed de usuários (#37_users.rb)"
  exit
end

mensagens_operacionais = [
  "Prezado(a), poderia verificar a proposta #123?",
  "Cliente solicitou revisão das condições de pagamento.",
  "Reunião marcada para amanhã às 14h.",
  "Documentação do cliente recebida, favor analisar.",
  "Urgente: Cliente aguardando retorno sobre limite.",
  "Proposta aprovada pelo comitê.",
  "Necessário regularizar pendências do cadastro.",
  "Encaminhando planilha atualizada de comissões.",
  "Novo procedimento para análise de crédito.",
  "Feedback da última apresentação ao cliente."
]

mensagens_administrativas = [
  "Lembrete: Treinamento amanhã às 9h.",
  "Por favor, atualize seu relatório semanal.",
  "Nova política de atendimento disponível na intranet.",
  "Confirmação de participação no evento requerida.",
  "Sistema ficará indisponível para manutenção hoje às 22h.",
  "Reunião de equipe antecipada para 15h.",
  "Favor validar os números do fechamento mensal.",
  "Novo material de treinamento disponível.",
  "Alteração no horário do plantão desta semana.",
  "Convite para confraternização da equipe."
]

data_inicial = 30.days.ago
data_final = Time.now

total_mensagens = 100

puts "Gerando #{total_mensagens} mensagens entre usuários..."

total_mensagens.times do |i|
  sender = users.sample
  recipient = users.reject { |u| u == sender }.sample
  
  mensagem = if rand < 0.7
         mensagens_operacionais.sample
       else
         mensagens_administrativas.sample
       end
  
  data_mensagem = rand(data_inicial..data_final)
  dias_atras = (Time.now - data_mensagem).to_i / 86400
  chance_leitura = [1.0 - (dias_atras / 30.0), 0.1].max
  lida = rand < chance_leitura
  
  descartada = rand < 0.1
  
  message = Message.new(
  content: mensagem,
  sender_id: sender.id,
  recipient_id: recipient.id,
  read: lida,
  discarded_at: descartada ? rand(data_mensagem..Time.now) : nil,
  created_at: data_mensagem,
  updated_at: data_mensagem
  )
  
  if message.save
  mensagens_criadas += 1
  total_sucesso += 1
  status = if message.discarded_at
         "[DESCARTADA]"
       elsif message.read
         "[LIDA]"
       else
         "[NÃO LIDA]"
       end
  sender_name = sender.first_name.presence || sender.email
  recipient_name = recipient.first_name.presence || recipient.email
  puts "Mensagem criada: De #{sender_name} para #{recipient_name} #{status}"
  else
  total_erros += 1
  puts "ERRO ao criar mensagem: #{message.errors.full_messages.join(', ')}"
  end
end

3.times do
  usuario1, usuario2 = users.sample(2)
  
  5.times do |i|
  sender = i.even? ? usuario1 : usuario2
  recipient = i.even? ? usuario2 : usuario1
  
  mensagem = "Mensagem #{i + 1} da conversa: " + mensagens_operacionais.sample
  
  tempo = Time.now - (rand(1..24) * i).hours
  
  Message.create!(
    content: mensagem,
    sender_id: sender.id,
    recipient_id: recipient.id,
    read: i < 4,
    created_at: tempo,
    updated_at: tempo
  )
  
  mensagens_criadas += 1
  end
  
  puts "Conversa criada entre #{usuario1.email} e #{usuario2.email} (5 mensagens)"
end

total_lidas = Message.where(read: true).count
total_nao_lidas = Message.where(read: false).count
total_descartadas = Message.where.not(discarded_at: nil).count

puts "\nEstatísticas das mensagens:"
puts "Total de mensagens criadas com sucesso: #{total_sucesso}"
puts "Total de erros: #{total_erros}" if total_erros > 0
puts "Mensagens lidas: #{total_lidas} (#{(total_lidas.to_f / mensagens_criadas * 100).round(1)}%)"
puts "Mensagens não lidas: #{total_nao_lidas} (#{(total_nao_lidas.to_f / mensagens_criadas * 100).round(1)}%)"
puts "Mensagens descartadas: #{total_descartadas} (#{(total_descartadas.to_f / mensagens_criadas * 100).round(1)}%)"

puts "\nRanking de usuários por mensagens enviadas:"
top_senders = Message.group(:sender_id)
          .count
          .sort_by { |_, count| -count }
          .first(5)

top_senders.each.with_index(1) do |(user_id, count), index|
  user = User.find(user_id)
  display_name = user.first_name.presence || user.email
  puts "#{index}º - #{display_name}: #{count} mensagens"
end

puts "\nProcesso de criação de mensagens concluído com sucesso!"
