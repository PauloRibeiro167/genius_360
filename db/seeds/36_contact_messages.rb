total_mensagens = 0
total_sucessos = 0
total_erros = 0

begin
    request_types = [
      :informacao,
      :orcamento,
      :suporte,
      :reclamacao,
      :sugestao,
      :parceria,
      :demonstracao
    ]

    statuses = [
      :nova,
      :em_analise, 
      :respondida,
      :encerrada,
      :pendente
    ]

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

    first_names = ["João", "Maria", "Pedro", "Ana", "Lucas", "Juliana", "Marcos", "Carla", "Roberto", "Paula", "Thiago", "Fernanda", "Ricardo", "Patrícia", "Diego"]
    last_names = ["Silva", "Santos", "Oliveira", "Souza", "Lima", "Pereira", "Costa", "Rodrigues", "Almeida", "Nascimento", "Ferreira", "Carvalho", "Gomes", "Martins"]

    30.times do |i|
        begin
            first_name = first_names.sample
            last_name = last_names.sample
            full_name = "#{first_name} #{last_name}"
            email = "#{first_name.downcase}.#{last_name.downcase}#{rand(100..999)}@email.com"
            phone = "(#{rand(10..99)}) #{rand(9)}#{rand(8000..9999)}-#{rand(1000..9999)}"
            message = message_texts.sample
            request_type = request_types.sample
            status = statuses.sample
            created_at = Time.now - rand(1..30).days
            
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
                total_sucessos += 1
            else
                total_erros += 1
            end
        rescue => e
            total_erros += 1
        end
    end

    User.limit(5).each do |user|
        begin
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
                total_sucessos += 1
            else
                total_erros += 1
            end
        rescue => e
            total_erros += 1
        end
    end

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
          status: :nova,
          created_at: Time.now - rand(1..3).hours
        )
        
        if contact_message.save
            total_sucessos += 1
        else
            total_erros += 1
        end
    end

    total_mensagens = ContactMessage.count

rescue => e
    exit
end
