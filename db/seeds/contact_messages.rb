puts "\nCriando mensagens de contato para testes..."

# Tipos de solicitação possíveis
request_types = [
  "Informação",
  "Orçamento",
  "Suporte",
  "Reclamação",
  "Sugestão",
  "Parceria",
  "Demonstração"
]

# Status possíveis para as mensagens
statuses = [
  "Nova",
  "Em análise",
  "Respondida",
  "Encerrada",
  "Pendente"
]

# Lista de mensagens fictícias
message_texts = [
  "Gostaria de receber mais informações sobre os serviços oferecidos.",
  "Estou com dificuldades para acessar minha conta. Podem me ajudar?",
  "Quero parabenizar pelo excelente atendimento que recebi ontem!",
  "Precisamos de um orçamento para implementação do sistema em nossa empresa.",
  "Estou tendo problemas com a integração do sistema. Preciso de ajuda técnica urgente.",
  "Tenho interesse em conhecer melhor a plataforma. É possível agendar uma demonstração?",
  "Gostaria de sugerir uma nova funcionalidade para o sistema.",
  "Estou enfrentando lentidão no dashboard. Como posso resolver?",
  "Quero reportar um bug encontrado no módulo de relatórios.",
  "Gostaria de saber sobre oportunidades de parceria com a Genius360.",
  "Preciso de ajuda para configurar os perfis de usuários do meu time.",
  "Como faço para atualizar meus dados cadastrais no sistema?",
  "Estou interessado em conhecer os planos de assinatura disponíveis.",
  "Preciso de suporte para migrar dados do meu sistema atual para o Genius360.",
  "Qual o prazo de implementação do sistema para uma empresa de médio porte?"
]

# Gera nomes aleatórios para contatos (nome e sobrenome)
first_names = ["João", "Maria", "Pedro", "Ana", "Lucas", "Juliana", "Marcos", "Carla", "Roberto", "Paula", "Thiago", "Fernanda", "Ricardo", "Patrícia", "Diego"]
last_names = ["Silva", "Santos", "Oliveira", "Souza", "Lima", "Pereira", "Costa", "Rodrigues", "Almeida", "Nascimento", "Ferreira", "Carvalho", "Gomes", "Martins"]

# Gera 30 mensagens de contato com dados aleatórios
30.times do |i|
  # Gera dados aleatórios para cada mensagem
  first_name = first_names.sample
  last_name = last_names.sample
  full_name = "#{first_name} #{last_name}"
  
  # Gera um email baseado no nome
  email = "#{first_name.downcase}.#{last_name.downcase}#{rand(100..999)}@email.com"
  
  # Gera um telefone aleatório
  phone = "(#{rand(10..99)}) #{rand(9)}#{rand(8000..9999)}-#{rand(1000..9999)}"
  
  # Seleciona uma mensagem, tipo de solicitação e status aleatório
  message = message_texts.sample
  request_type = request_types.sample
  status = statuses.sample
  
  # Define data de criação dentro dos últimos 30 dias
  created_at = Time.now - rand(1..30).days
  
  # Cria a mensagem de contato
  contact_message = ContactMessage.new(
    name: full_name,
    email: email,
    phone: phone,
    message: message,
    request_type: request_type,
    status: status,
    created_at: created_at,
    updated_at: created_at
  )
  
  if contact_message.save
    puts "Mensagem de contato ##{i+1} criada: #{full_name} (#{request_type}) - Status: #{status}"
  else
    puts "Erro ao criar mensagem de contato ##{i+1}: #{contact_message.errors.full_messages.join(', ')}"
  end
end

# Cria algumas mensagens usando dados dos usuários existentes para representar contatos de clientes reais
User.limit(5).each_with_index do |user, index|
  contact_message = ContactMessage.new(
    name: "#{user.first_name} #{user.last_name}",
    email: user.email,
    phone: user.phone,
    message: "Esta é uma mensagem de teste de um usuário cadastrado no sistema. #{message_texts.sample}",
    request_type: request_types.sample,
    status: statuses.sample,
    created_at: Time.now - rand(1..10).days
  )
  
  if contact_message.save
    puts "Mensagem de contato criada para usuário existente: #{user.email}"
  else
    puts "Erro ao criar mensagem para usuário existente: #{contact_message.errors.full_messages.join(', ')}"
  end
end

# Adiciona algumas mensagens com status "Nova" para testes de fluxo de atendimento
3.times do |i|
  first_name = first_names.sample
  last_name = last_names.sample
  full_name = "#{first_name} #{last_name}"
  email = "#{first_name.downcase}.#{last_name.downcase}#{rand(100..999)}@email.com"
  phone = "(#{rand(10..99)}) #{rand(9)}#{rand(8000..9999)}-#{rand(1000..9999)}"
  
  contact_message = ContactMessage.new(
    name: full_name,
    email: email,
    phone: phone,
    message: "URGENTE: #{message_texts.sample}",
    request_type: request_types.sample,
    status: "Nova",
    created_at: Time.now - rand(1..3).hours
  )
  
  if contact_message.save
    puts "Nova mensagem urgente criada: #{full_name}"
  else
    puts "Erro ao criar mensagem urgente: #{contact_message.errors.full_messages.join(', ')}"
  end
end

puts "\nCriação de mensagens de contato concluída! Total: #{ContactMessage.count} mensagens."