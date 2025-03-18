success_count = 0
error_count = 0

def create_notification(user, type, data_item, created_at, read_at, notification_urls)
  Notification.new(
    user: user,
    type: type,
    data: {
      title: data_item[:title],
      content: data_item[:content],
      url: notification_urls[type]
    },
    url: notification_urls[type],
    read_at: read_at,
    created_at: created_at,
    updated_at: created_at
  )
end

puts "\n Iniciando criação de notificações de teste..."

if User.count.zero?
    puts "Erro: Nenhum usuário encontrado. Execute primeiro a seed de usuários."
    return
end

puts "#{User.count} usuários encontrados"

notification_types = [
  "SystemAlert",
  "UserMessage",
  "TaskAssignment",
  "ContactRequest",
  "UpdateAlert",
  "SecurityAlert",
  "ReportReady",
  "NewFeature",
  "AccountActivity"
]

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

User.all.each do |user|
    begin
        notification_count = rand(3..10)
        puts "Processando usuário: #{user.email}"
        
        notification_count.times do
            type = notification_types.sample
            data_item = notification_data[type].sample
            created_at = Time.now - rand(1..14).days
            read_at = rand < 0.3 ? Time.now - rand(1..72).hours : nil
            
            notification = create_notification(
                user,
                type,
                data_item,
                created_at,
                read_at,
                notification_urls
            )
            
            if notification.save
                success_count += 1
                puts "Notificação criada: #{type}"
            else
                error_count += 1
                puts "Erro ao criar notificação: #{notification.errors.full_messages.join(', ')}"
            end
        end
    rescue => e
        error_count += 1
        puts "Erro: #{user.email} - #{e.message}"
    end
end

puts "\n Iniciando criação de notificações recentes..."
User.limit(5).each do |user|
    puts "Processando notificações para #{user.email}"
    3.times do
        type = notification_types.sample
        data_item = notification_data[type].sample
        created_at = Time.now - rand(1..24).hours
        
        notification = create_notification(
            user,
            type,
            data_item,
            created_at,
            nil,
            notification_urls
        )
        
        if notification.save
            puts "Notificação criada: #{type}"
        else
            puts "Erro ao criar notificação: #{notification.errors.full_messages.join(', ')}"
        end
    end
end

admin_user = User.find_by(email: 'admin@genius360.com')

if admin_user
    puts "\n Criando notificações para administrador..."
    15.times do
        type = notification_types.sample
        data_item = notification_data[type].sample
        created_at = Time.now - rand(1..30).days
        read_at = rand < 0.5 ? Time.now - rand(1..24).hours : nil
        
        notification = create_notification(
            admin_user,
            type,
            data_item,
            created_at,
            read_at,
            notification_urls
        )
        
        if notification.save
            puts "Notificação admin: #{type}"
        else
            puts "Erro em notificação admin: #{notification.errors.full_messages.join(', ')}"
        end
    end
    puts "Criadas 15 notificações para #{admin_user.email}"
end

puts "\n Resumo da operação:"
puts "Total de sucessos: #{success_count}"
puts "Total de erros: #{error_count}"
puts "Notificações no sistema: #{Notification.count}"
puts "Notificações não lidas: #{Notification.where(read_at: nil).count}"
