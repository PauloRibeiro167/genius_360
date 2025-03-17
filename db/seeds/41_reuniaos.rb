require 'colorize'

# Função para normalizar texto
def normalizar_texto(texto)
    return nil if texto.nil?
    texto.to_s
         .unicode_normalize(:nfkd)
         .gsub(/[^\x00-\x7F]/, '')
         .gsub(/[^\w\s-]/, ' ')
         .squeeze(' ')
         .strip
end

# Contadores para estatísticas
total_reunioes = 0
reunioes_criadas = 0
reunioes_com_erro = 0
participantes_criados = 0
disponibilidades_criadas = 0

puts "\n Iniciando criação de reuniões e disponibilidades...".colorize(:blue)

# Verifica se existem usuários no sistema
if User.count < 5
    puts "🟡 Aviso: É necessário ter pelo menos 5 usuários no sistema.".colorize(:yellow)
    puts " Execute primeiro a seed de usuários".colorize(:yellow)
    return
end

# Lista de salas de reunião físicas
salas_fisicas = [
  "Sala de Reunião 01 - Térreo",
  "Sala de Reunião 02 - Térreo",
  "Sala de Reunião VIP - 5º andar",
  "Auditório Principal",
  "Sala de Treinamento 01",
  "Sala de Treinamento 02",
  "Sala de Conferência - 10º andar"
]

# Locais físicos
locais_fisicos = [
  "Sede Principal - Fortaleza",
  "Filial São Paulo",
  "Filial Rio de Janeiro",
  "Escritório Remoto - Recife",
  "Centro de Treinamento",
  "Cliente - Empresa ABC",
  "Hotel Business Center"
]

# Plataformas virtuais
plataformas_virtuais = [
  "Microsoft Teams",
  "Zoom",
  "Google Meet",
  "Cisco Webex",
  "Skype Empresarial"
]

# Status possíveis para reuniões
status_reunioes = ["agendada", "confirmada", "cancelada", "finalizada"]

# Títulos de reuniões
titulos_reunioes = [
  "Planejamento Estratégico Q2 2025",
  "Análise de Resultados Mensais",
  "Apresentação de Novos Produtos",
  "Alinhamento de Equipe",
  "Revisão de Projetos em Andamento",
  "Orçamento Anual",
  "Treinamento de Nova Plataforma",
  "Feedback de Clientes",
  "Inovação e Tendências de Mercado",
  "Integração de Novos Colaboradores",
  "Plano de Marketing Digital",
  "Reunião de Diretoria",
  "Definição de KPIs",
  "Revisão de Processos Internos",
  "Brainstorming de Novas Funcionalidades",
  "Alinhamento com Fornecedores",
  "Pesquisa e Desenvolvimento",
  "Acompanhamento de Metas"
]

# Pega todos os usuários
users = User.all
organizadores = User.where(admin: true).or(User.where("email LIKE ?", "%gerente%")).or(User.where("email LIKE ?", "%diretor%"))
organizadores = users.sample(3) if organizadores.empty?

# Criar disponibilidades para todos os usuários
puts "\n Iniciando criação de disponibilidades...".colorize(:cyan)
dias_semana = ["Segunda", "Terça", "Quarta", "Quinta", "Sexta"]

users.each do |user|
  begin
    # Para cada usuário, cria disponibilidades para os dias da semana
    dias_semana.each do |dia|
      # Define horários de trabalho padrão (8h às 18h)
      hora_inicio = Time.parse("08:00:00")
      hora_fim = Time.parse("18:00:00")
      
      # Alguns usuários têm disponibilidade reduzida em alguns dias
      if rand < 0.2
        # 20% de chance de ter horário reduzido
        hora_inicio = Time.parse("10:00:00")
        hora_fim = Time.parse("16:00:00")
      end
      
      # Alguns usuários não estão disponíveis em alguns dias
      disponivel = rand < 0.9 # 90% de chance de estar disponível
      
      disponibilidade = Disponibilidade.new(
        user_id: user.id,
        dia_semana: dia,
        hora_inicio: hora_inicio,
        hora_fim: hora_fim,
        disponivel: disponivel
      )
      
      if disponibilidade.save
        disponibilidades_criadas += 1
        puts "🟢 Disponibilidade criada para #{user.email} - #{dia}".colorize(:green)
      else
        puts " Erro ao criar disponibilidade: #{disponibilidade.errors.full_messages.join(', ')}".colorize(:red)
      end
    end
  rescue => e
    puts " Erro ao processar disponibilidades: #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
  end
  
  puts "Disponibilidades criadas para #{user.email}"
end

# Criar reuniões
puts "\n Iniciando criação de reuniões...".colorize(:blue)

# Datas para as reuniões (passado, presente e futuro)
data_atual = Time.now

# Cria 20 reuniões
20.times do |i|
  # Define se é uma reunião passada, presente ou futura
  tipo_data = rand(100)
  
  if tipo_data < 30
    # Reunião passada (30%)
    data_inicio = data_atual - rand(1..30).days
    status = ["confirmada", "finalizada", "cancelada"].sample
  elsif tipo_data < 40
    # Reunião no dia atual (10%)
    data_inicio = data_atual + rand(-3..3).hours
    status = ["confirmada", "agendada"].sample
  else
    # Reunião futura (60%)
    data_inicio = data_atual + rand(1..14).days
    status = ["agendada", "confirmada"].sample
  end
  
  # Define duração da reunião (entre 30 min e 3 horas)
  duracao = rand(30..180).minutes
  data_fim = data_inicio + duracao
  
  # Define se é virtual, presencial ou híbrida
  formato = rand(100)
  local_fisico = nil
  sala = nil
  link_reuniao = nil
  plataforma_virtual = nil
  
  if formato < 40
    # Reunião presencial (40%)
    local_fisico = locais_fisicos.sample
    sala = salas_fisicas.sample
  elsif formato < 80
    # Reunião virtual (40%)
    plataforma_virtual = plataformas_virtuais.sample
    link_reuniao = "https://meet.#{plataforma_virtual.downcase.gsub(' ', '')}.com/#{SecureRandom.alphanumeric(9)}"
  else
    # Reunião híbrida (20%)
    local_fisico = locais_fisicos.sample
    sala = salas_fisicas.sample
    plataforma_virtual = plataformas_virtuais.sample
    link_reuniao = "https://meet.#{plataforma_virtual.downcase.gsub(' ', '')}.com/#{SecureRandom.alphanumeric(9)}"
  end
  
  # Escolhe um organizador
  organizador = organizadores.sample
  
  # Título e descrição
  titulo = titulos_reunioes.sample
  descricao = "Reunião para discussão de #{titulo.downcase}. " + 
              "Participantes devem preparar material relacionado e revisar os documentos compartilhados anteriormente. " +
              "Agenda: 1) Abertura e alinhamento de expectativas; 2) Apresentação dos tópicos principais; " +
              "3) Discussão e definição de próximos passos; 4) Encerramento."
  
  # Cria a reunião
  reuniao = Reuniao.new(
    titulo: titulo,
    descricao: descricao,
    data_inicio: data_inicio,
    data_fim: data_fim,
    local_fisico: local_fisico,
    sala: sala,
    link_reuniao: link_reuniao,
    plataforma_virtual: plataforma_virtual,
    status: status,
    organizador_id: organizador.id
  )
  
  if reuniao.save
    reunioes_criadas += 1
    puts "Reunião criada: #{titulo} (#{status}) - Organizador: #{organizador.email}"
    
    # Adiciona participantes (entre 3 e 8 participantes)
    participantes_count = rand(3..8)
    participantes_usuarios = users.reject { |u| u.id == organizador.id }.sample(participantes_count)
    
    participantes_usuarios.each do |participante|
      # Define status do participante
      status_participante = if reuniao.status == "finalizada"
                            ["confirmado", "recusado"].sample
                          elsif reuniao.status == "confirmada"
                            ["confirmado", "pendente", "recusado"].sample
                          else
                            ["pendente", "confirmado"].sample
                          end
      
      # Adiciona observações para alguns participantes
      observacoes = nil
      if rand < 0.3 # 30% de chance de ter observações
        observacoes = [
          "Preciso sair 15 minutos antes do fim da reunião.",
          "Vou me atrasar cerca de 10 minutos.",
          "Posso apresentar o relatório de vendas.",
          "Confirmo presença, mas participarei remotamente.",
          "Trarei documentação adicional sobre o tema."
        ].sample
      end
      
      # Cria o participante
      participante = Participante.create(
        reuniao_id: reuniao.id,
        user_id: participante.id,
        status: status_participante,
        observacoes: observacoes
      )
      participantes_criados += 1
    end
    
    puts "  #{participantes_count} participantes adicionados"
  else
    reunioes_com_erro += 1
    puts "Erro ao criar reunião: #{reuniao.errors.full_messages.join(', ')}"
  end
end

# Adiciona algumas reuniões recorrentes
puts "\nCriando reuniões recorrentes..."

# Reunião recorrente semanal
3.times do |semana|
  reuniao_recorrente = Reuniao.new(
    titulo: "Reunião Semanal de Acompanhamento",
    descricao: "Reunião semanal para acompanhamento das atividades em andamento e alinhamento de prioridades.",
    data_inicio: data_atual + semana.weeks + 1.day + 14.hours, # Toda terça às 14h
    data_fim: data_atual + semana.weeks + 1.day + 15.hours,    # Duração de 1 hora
    local_fisico: "Sede Principal - Fortaleza",
    sala: "Sala de Reunião 01 - Térreo",
    status: "agendada",
    organizador_id: organizadores.first.id
  )
  
  if reuniao_recorrente.save
    # Adiciona os mesmos participantes para todas as recorrências
    participantes_recorrentes = users.sample(5)
    
    participantes_recorrentes.each do |participante|
      Participante.create(
        reuniao_id: reuniao_recorrente.id,
        user_id: participante.id,
        status: "pendente"
      )
      participantes_criados += 1
    end
    
    puts "Reunião recorrente semanal criada para #{reuniao_recorrente.data_inicio.strftime('%d/%m/%Y')}"
  end
end

# Reunião mensal
2.times do |mes|
  reuniao_mensal = Reuniao.new(
    titulo: "Reunião Mensal de Resultados",
    descricao: "Apresentação e análise dos resultados do mês anterior, definição de metas e estratégias para o próximo período.",
    data_inicio: data_atual + mes.months + 5.days + 10.hours, # Todo dia 5 às 10h
    data_fim: data_atual + mes.months + 5.days + 12.hours,    # Duração de 2 horas
    plataforma_virtual: "Microsoft Teams",
    link_reuniao: "https://teams.microsoft.com/meeting/#{SecureRandom.alphanumeric(12)}",
    status: "agendada",
    organizador_id: organizadores.last.id
  )
  
  if reuniao_mensal.save
    # Todos participam da reunião mensal
    users.each do |user|
      Participante.create(
        reuniao_id: reuniao_mensal.id,
        user_id: user.id,
        status: "pendente"
      )
      participantes_criados += 1
    end
    
    puts "Reunião mensal criada para #{reuniao_mensal.data_inicio.strftime('%d/%m/%Y')}"
  end
end

puts "\n=== Resumo da Operação ===".colorize(:white)
puts "⚪ Total de reuniões processadas: #{total_reunioes}".colorize(:white)
puts "🟢 Reuniões criadas com sucesso: #{reunioes_criadas}".colorize(:green)
puts " Reuniões com erro: #{reunioes_com_erro}".colorize(:red)
puts " Disponibilidades criadas: #{disponibilidades_criadas}".colorize(:cyan)
puts " Participantes criados: #{participantes_criados}".colorize(:cyan)
puts "⚫ Operação finalizada em: #{Time.now}".colorize(:light_black)

puts "\nCriação de reuniões concluída!"
puts "Total: #{Reuniao.count} reuniões, #{Participante.count} participantes e #{Disponibilidade.count} registros de disponibilidade."