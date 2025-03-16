require 'colorize'

# Função de normalização
def normalizar_nome(texto)
    return nil if texto.nil?
    texto.strip
         .gsub(/[áàãâä]/, 'a')
         .gsub(/[éèêë]/, 'e')
         .gsub(/[íìîï]/, 'i')
         .gsub(/[óòõôö]/, 'o')
         .gsub(/[úùûü]/, 'u')
         .gsub(/[ç]/, 'c')
         .gsub(/[ÁÀÃÂÄ]/, 'A')
         .gsub(/[ÉÈÊË]/, 'E')
         .gsub(/[ÍÌÎÏ]/, 'I')
         .gsub(/[ÓÒÕÔÖ]/, 'O')
         .gsub(/[ÚÙÛÜ]/, 'U')
         .gsub(/[Ç]/, 'C')
         .gsub(/[^0-9A-Za-z\s]/, '')
         .upcase
end

# Inicialização de contadores
total_mensagens = 0
total_sucessos = 0
total_erros = 0

puts " Iniciando criação de mensagens de contato para testes...".colorize(:blue)

begin
    # Tipos de solicitação possíveis (alterado para corresponder ao enum)
    request_types = [
      :informacao,
      :orcamento,
      :suporte,
      :reclamacao,
      :sugestao,
      :parceria,
      :demonstracao
    ]

    # Status possíveis para as mensagens (alterado para corresponder ao enum)
    statuses = [
      :nova,
      :em_analise, 
      :respondida,
      :encerrada,
      :pendente
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

    puts "⚪ Gerando mensagens de contato aleatórias...".colorize(:white)
    
    # Gera 30 mensagens de contato com dados aleatórios
    30.times do |i|
        begin
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
                total_sucessos += 1
                puts "🟢 Mensagem ##{i+1} criada: #{full_name} (#{request_type})".colorize(:green)
            else
                total_erros += 1
                puts " Erro ao criar mensagem ##{i+1}: #{contact_message.errors.full_messages.join(', ')}".colorize(:red)
            end
        rescue => e
            total_erros += 1
            puts " Erro inesperado: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
        end
    end

    puts "\n Processando mensagens de usuários existentes...".colorize(:blue)
    User.limit(5).each_with_index do |user, index|
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
                puts "🟢 Mensagem criada para: #{user.email}".colorize(:green)
            else
                total_erros += 1
                puts " Erro: #{contact_message.errors.full_messages.join(', ')}".colorize(:red)
            end
        rescue => e
            total_erros += 1
            puts " Erro ao processar usuário: #{e.message}".colorize(:red)
        end
    end

    puts "\n Criando mensagens urgentes...".colorize(:blue)
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
            puts "🟢 Mensagem urgente criada: #{full_name}".colorize(:green)
        else
            total_erros += 1
            puts " Erro: #{contact_message.errors.full_messages.join(', ')}".colorize(:red)
        end
    end

    # Resumo final
    total_mensagens = ContactMessage.count
    puts "\n⚪ Resumo da Operação".colorize(:white)
    puts "🟢 Total de sucessos: #{total_sucessos}".colorize(:green)
    puts " Total de erros: #{total_erros}".colorize(:red)
    puts "⚫ Total de mensagens no sistema: #{total_mensagens}".colorize(:light_black)
    
    if total_erros.zero?
        puts "🟢 Processo finalizado com sucesso!".colorize(:green)
    else
        puts "🟡 Processo finalizado com alertas".colorize(:yellow)
    end

rescue => e
    puts " ERRO FATAL: #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
    exit
end