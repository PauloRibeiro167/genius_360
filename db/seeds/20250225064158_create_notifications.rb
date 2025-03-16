puts "\nCriando notificações de teste para usuários..."

# Verifica se existem usuários no sistema
if User.count.zero?
  puts "Nenhum usuário encontrado. Execute primeiro a seed de usuários."
  return
end

# Tipos de notificações possíveis
notification_types = [
  "SystemAlert",       # Alertas do sistema
  "UserMessage",       # Mensagens de outros usuários
  "TaskAssignment",    # Atribuição de tarefas
  "ContactRequest",    # Pedidos de contato
  "UpdateAlert",       # Alertas de atualização
  "SecurityAlert",     # Alertas de segurança
  "ReportReady",       # Relatórios prontos
  "NewFeature",        # Novas funcionalidades
  "AccountActivity"    # Atividades da conta
]

# Dados para cada tipo de notificação
notification_data = {
  "SystemAlert" => [
    { title: "Manutenção Programada", content: "O sistema estará indisponível para manutenção no próximo domingo, das 02h às 04h." },
    { title: "Nova Versão Disponível", content: "A versão 2.5 do sistema foi lançada com melhorias de performance." },
    { title: "Backup Concluído", content: "O backup automático foi concluído com sucesso." }
  ],
  "UserMessage" => [
    { title: "Nova mensagem", content: "Você recebeu uma nova mensagem de Paulo Ribeiro." },
    { title: "Mensagem não lida", content: "Você tem mensagens não lidas de Maria Marketing." },
    { title: "Resposta recebida", content: "Sua mensagem foi respondida por Carlos Relacionamento." }
  ],
  "TaskAssignment" => [
    { title: "Nova tarefa atribuída", content: "Uma nova tarefa foi atribuída a você: Análise de dados mensal." },
    { title: "Prazo se aproximando", content: "O prazo da tarefa 'Relatório trimestral' vence em 2 dias." },
    { title: "Tarefa concluída", content: "A tarefa 'Integração de API' foi marcada como concluída." }
  ],
  "ContactRequest" => [
    { title: "Novo pedido de contato", content: "Um cliente solicitou informações sobre o serviço de consultoria." },
    { title: "Solicitação de suporte", content: "Um usuário precisa de ajuda com o módulo de relatórios." },
    { title: "Solicitação de demonstração", content: "Empresa ABC solicitou uma demonstração do sistema." }
  ],
  "UpdateAlert" => [
    { title: "Atualização de perfil", content: "As permissões do seu perfil foram atualizadas pelo administrador." },
    { title: "Módulo atualizado", content: "O módulo de dashboard foi atualizado com novos gráficos." },
    { title: "Dados sincronizados", content: "Seus dados foram sincronizados com sucesso." }
  ],
  "SecurityAlert" => [
    { title: "Acesso de novo dispositivo", content: "Detectamos um acesso à sua conta de um novo dispositivo." },
    { title: "Senha alterada", content: "Sua senha foi alterada recentemente. Não foi você? Entre em contato conosco." },
    { title: "Tentativas de login", content: "Múltiplas tentativas de login foram detectadas na sua conta." }
  ],
  "ReportReady" => [
    { title: "Relatório mensal pronto", content: "O relatório mensal de desempenho está disponível para visualização." },
    { title: "Análise de dados concluída", content: "A análise dos dados solicitada foi concluída." },
    { title: "Exportação finalizada", content: "Sua exportação de dados foi concluída e está pronta para download." }
  ],
  "NewFeature" => [
    { title: "Nova funcionalidade", content: "Conheça nossa nova funcionalidade de análise preditiva!" },
    { title: "Dashboard personalizado", content: "Agora você pode personalizar completamente seu dashboard." },
    { title: "Integração disponível", content: "Nova integração com Google Analytics está disponível." }
  ],
  "AccountActivity" => [
    { title: "Login detectado", content: "Um login foi realizado em sua conta há 5 minutos." },
    { title: "Perfil atualizado", content: "Seu perfil foi atualizado recentemente." },
    { title: "Email confirmado", content: "Seu novo endereço de email foi confirmado com sucesso." }
  ]
}

# URLs correspondentes para cada tipo de notificação
notification_urls = {
  "SystemAlert" => "/system/alerts",
  "UserMessage" => "/messages",
  "TaskAssignment" => "/tasks",
  "ContactRequest" => "/contacts",
  "UpdateAlert" => "/updates",
  "SecurityAlert" => "/security",
  "ReportReady" => "/reports",
  "NewFeature" => "/features",
  "AccountActivity" => "/account/activity"
}

# Cria notificações para cada usuário
User.all.each do |user|
  # Quantidade aleatória de notificações por usuário (entre 3 e 10)
  notification_count = rand(3..10)
  
  notification_count.times do
    # Escolhe aleatoriamente um tipo de notificação
    type = notification_types.sample
    
    # Escolhe aleatoriamente um item de dados desse tipo
    data_item = notification_data[type].sample
    
    # Determina se será lida ou não (70% de chance de não ser lida)
    read_at = rand < 0.3 ? Time.now - rand(1..72).hours : nil
    
    # Cria a notificação
    created_at = Time.now - rand(1..14).days
    notification = Notification.new(
      user: user,
      type: type,
      data: data_item,
      read_at: read_at,
      url: notification_urls[type],
      created_at: created_at,
      updated_at: created_at
    )
    
    if notification.save
      status = read_at.nil? ? "não lida" : "lida"
      puts "Notificação criada para #{user.email}: #{type} (#{status})"
    else
      puts "Erro ao criar notificação para #{user.email}: #{notification.errors.full_messages.join(', ')}"
    end
  end
end

# Criar algumas notificações recentes (últimas 24 horas) e não lidas para testes
puts "\nCriando notificações recentes não lidas..."
User.limit(5).each do |user|
  3.times do
    type = notification_types.sample
    data_item = notification_data[type].sample
    created_at = Time.now - rand(1..24).hours
    
    notification = Notification.new(
      user: user,
      type: type,
      data: data_item,
      read_at: nil,
      url: notification_urls[type],
      created_at: created_at,
      updated_at: created_at
    )
    
    if notification.save
      puts "Notificação recente não lida criada para #{user.email}: #{type}"
    else
      puts "Erro ao criar notificação recente para #{user.email}: #{notification.errors.full_messages.join(', ')}"
    end
  end
end

# Criar algumas notificações em massa para um usuário específico (para testar paginação)
admin_user = User.find_by(email: 'admin@genius360.com')
if admin_user
  puts "\nCriando múltiplas notificações para o usuário admin..."
  15.times do |i|
    type = notification_types.sample
    data_item = notification_data[type].sample
    created_at = Time.now - rand(1..30).days
    read_at = rand < 0.5 ? Time.now - rand(1..24).hours : nil
    
    notification = Notification.new(
      user: admin_user,
      type: type,
      data: data_item,
      read_at: read_at,
      url: notification_urls[type],
      created_at: created_at,
      updated_at: created_at
    )
    
    notification.save
  end
  puts "15 notificações adicionais criadas para #{admin_user.email}"
end

total_count = Notification.count
unread_count = Notification.where(read_at: nil).count
puts "\nCriação de notificações concluída! Total: #{total_count} notificações (#{unread_count} não lidas)"