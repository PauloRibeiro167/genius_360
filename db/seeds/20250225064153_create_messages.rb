puts "Criando mensagens entre usuários para demonstração..."

# Limpa registros existentes para evitar duplicações
# Message.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários no sistema
users = User.all
if users.count < 2
  puts "ATENÇÃO: É necessário ter pelo menos 2 usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

# Conteúdos possíveis para as mensagens
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

# Período para as mensagens
data_inicial = 30.days.ago
data_final = Time.now

# Número de mensagens a serem criadas
mensagens_criadas = 0
total_mensagens = 100 # Ajuste conforme necessário

puts "Gerando #{total_mensagens} mensagens entre usuários..."

# Cria mensagens entre usuários
total_mensagens.times do |i|
  # Seleciona remetente e destinatário diferentes
  sender = users.sample
  recipient = users.reject { |u| u == sender }.sample
  
  # Define se é uma mensagem operacional ou administrativa
  mensagem = if rand < 0.7
               mensagens_operacionais.sample # 70% operacionais
             else
               mensagens_administrativas.sample # 30% administrativas
             end
  
  # Define se a mensagem foi lida (mensagens mais antigas têm mais chance de terem sido lidas)
  data_mensagem = rand(data_inicial..data_final)
  dias_atras = (Time.now - data_mensagem).to_i / 86400
  chance_leitura = [1.0 - (dias_atras / 30.0), 0.1].max # Quanto mais antiga, maior a chance de ter sido lida
  lida = rand < chance_leitura
  
  # Define se a mensagem foi descartada
  descartada = rand < 0.1 # 10% de chance de estar descartada
  
  # Cria a mensagem
  message = Message.new(
    content: mensagem,
    sender: sender,
    recipient: recipient,
    read: lida,
    discarded_at: descartada ? rand(data_mensagem..Time.now) : nil,
    created_at: data_mensagem,
    updated_at: data_mensagem
  )
  
  if message.save
    mensagens_criadas += 1
    status = if message.discarded_at
               "[DESCARTADA]"
             elsif message.read
               "[LIDA]"
             else
               "[NÃO LIDA]"
             end
    puts "Mensagem criada: De #{sender.email} para #{recipient.email} #{status}"
  else
    puts "ERRO ao criar mensagem: #{message.errors.full_messages.join(', ')}"
  end
end

# Cria algumas conversas longas entre pares específicos de usuários
3.times do
  # Seleciona dois usuários para a conversa
  usuario1, usuario2 = users.sample(2)
  
  # Cria uma sequência de 5 mensagens entre eles
  5.times do |i|
    # Alterna remetente e destinatário
    sender = i.even? ? usuario1 : usuario2
    recipient = i.even? ? usuario2 : usuario1
    
    # Cria mensagem da conversa
    mensagem = "Mensagem #{i + 1} da conversa: " + mensagens_operacionais.sample
    
    # Define tempo progressivo (mais recente)
    tempo = Time.now - (rand(1..24) * i).hours
    
    Message.create!(
      content: mensagem,
      sender: sender,
      recipient: recipient,
      read: i < 4, # Última mensagem não lida
      created_at: tempo,
      updated_at: tempo
    )
    
    mensagens_criadas += 1
  end
  
  puts "Conversa criada entre #{usuario1.email} e #{usuario2.email} (5 mensagens)"
end

# Estatísticas
total_lidas = Message.where(read: true).count
total_nao_lidas = Message.where(read: false).count
total_descartadas = Message.where.not(discarded_at: nil).count

puts "\nEstatísticas das mensagens:"
puts "- Total de mensagens criadas: #{mensagens_criadas}"
puts "- Mensagens lidas: #{total_lidas} (#{(total_lidas.to_f / mensagens_criadas * 100).round(1)}%)"
puts "- Mensagens não lidas: #{total_nao_lidas} (#{(total_nao_lidas.to_f / mensagens_criadas * 100).round(1)}%)"
puts "- Mensagens descartadas: #{total_descartadas} (#{(total_descartadas.to_f / mensagens_criadas * 100).round(1)}%)"

# Mensagens por usuário
puts "\nTop 5 usuários com mais mensagens enviadas:"
top_senders = Message.group(:sender_id)
                    .count
                    .sort_by { |_, count| -count }
                    .first(5)

top_senders.each do |user_id, count|
  user = User.find(user_id)
  puts "- #{user.email}: #{count} mensagens"
end

puts "\nMensagens criadas com sucesso!"