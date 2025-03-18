def exibir_barra_progresso(atual, total, source)
  porcentagem = (atual.to_f / total * 100).round
  barras_preenchidas = (porcentagem / 5).round
  barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
  print "\r Processando #{source}: [#{barra}] #{porcentagem}% (#{atual}/#{total})"
end

puts "\n Iniciando seed de reuniões..."
start_time = Time.now

total_reunioes = 20
total_processado = 0
sucessos = 0
erros = 0
participantes_criados = 0
data_atual = Time.now

begin
  if User.count < 5
    puts "\n É necessário ter pelo menos 5 usuários no sistema."
    puts "Execute primeiro: # db/seeds/29_users.rb"
    return
  end

  puts "\n Carregando dados de usuários..."
  users = User.all
  organizadores = User.where(admin: true)
             .or(User.where("email LIKE ?", "%gerente%"))
             .or(User.where("email LIKE ?", "%diretor%"))

  if organizadores.empty?
    puts "\n Nenhum organizador encontrado"
    puts "Selecionando usuários aleatoriamente..."
    organizadores = users.sample(3)
  end

  salas_fisicas = [
    "Sala de Reunião 01 - Térreo",
    "Sala de Reunião 02 - Térreo",
    "Sala de Reunião VIP - 5º andar",
    "Auditório Principal",
    "Sala de Treinamento 01",
    "Sala de Treinamento 02",
    "Sala de Conferência - 10º andar"
  ]

  locais_fisicos = [
    "Sede Principal - Fortaleza",
    "Filial São Paulo",
    "Filial Rio de Janeiro",
    "Escritório Remoto - Recife",
    "Centro de Treinamento",
    "Cliente - Empresa ABC",
    "Hotel Business Center"
  ]

  plataformas_virtuais = [
    "Microsoft Teams",
    "Zoom",
    "Google Meet",
    "Cisco Webex",
    "Skype Empresarial"
  ]

  status_reunioes = ["agendada", "confirmada", "cancelada", "finalizada"]

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

  puts "\n Iniciando criação das reuniões..."
  total_reunioes.times do |i|
    exibir_barra_progresso(i + 1, total_reunioes, "reuniões")
    begin
      tipo_data = rand(100)
      
      if tipo_data < 30
        data_inicio = data_atual - rand(1..30).days
        status = ["confirmada", "finalizada", "cancelada"].sample
      elsif tipo_data < 40
        data_inicio = data_atual + rand(-3..3).hours
        status = ["confirmada", "agendada"].sample
      else
        data_inicio = data_atual + rand(1..14).days
        status = ["agendada", "confirmada"].sample
      end
      
      duracao = rand(30..180).minutes
      data_fim = data_inicio + duracao
      
      formato = rand(100)
      local_fisico = nil
      sala = nil
      link_reuniao = nil
      plataforma_virtual = nil
      
      if formato < 40
        local_fisico = locais_fisicos.sample
        sala = salas_fisicas.sample
      elsif formato < 80
        plataforma_virtual = plataformas_virtuais.sample
        link_reuniao = "https://meet.#{plataforma_virtual.downcase.gsub(' ', '')}.com/#{SecureRandom.alphanumeric(9)}"
      else
        local_fisico = locais_fisicos.sample
        sala = salas_fisicas.sample
        plataforma_virtual = plataformas_virtuais.sample
        link_reuniao = "https://meet.#{plataforma_virtual.downcase.gsub(' ', '')}.com/#{SecureRandom.alphanumeric(9)}"
      end
      
      organizador = organizadores.sample
      
      titulo = titulos_reunioes.sample
      descricao = "Reunião para discussão de #{titulo.downcase}. " + 
            "Participantes devem preparar material relacionado e revisar os documentos compartilhados anteriormente. " +
            "Agenda: 1) Abertura e alinhamento de expectativas; 2) Apresentação dos tópicos principais; " +
            "3) Discussão e definição de próximos passos; 4) Encerramento."
      
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
        sucessos += 1
        puts "\n Reunião criada: #{reuniao.titulo}"
        puts "Status: #{reuniao.status}"
        puts "Organizador: #{reuniao.organizador.email}"
        
        participantes_count = rand(3..8)
        participantes_usuarios = users.reject { |u| u.id == organizador.id }.sample(participantes_count)
        
        participantes_usuarios.each do |participante|
          status_participante = if reuniao.status == "finalizada"
                    ["confirmado", "recusado"].sample
                    elsif reuniao.status == "confirmada"
                    ["confirmado", "pendente", "recusado"].sample
                    else
                    ["pendente", "confirmado"].sample
                    end
          
          observacoes = nil
          if rand < 0.3
          observacoes = [
            "Preciso sair 15 minutos antes do fim da reunião.",
            "Vou me atrasar cerca de 10 minutos.",
            "Posso apresentar o relatório de vendas.",
            "Confirmo presença, mas participarei remotamente.",
            "Trarei documentação adicional sobre o tema."
          ].sample
          end
          
          participante = Participante.create(
          reuniao_id: reuniao.id,
          user_id: participante.id,
          status: status_participante,
          observacoes: observacoes
          )
          participantes_criados += 1
        end
        
        puts "#{participantes_count} participantes adicionados"
      else
        erros += 1
        puts "\n Erro ao criar reunião:"
        puts "Debug: #{reuniao.errors.full_messages.join(', ')}"
      end
    rescue => e
      erros += 1
      puts "\n Erro inesperado durante a criação:"
      puts "Debug: #{e.message}"
    end
    total_processado += 1
  end

  puts "\n Criando reuniões recorrentes..."
  
  3.times do |semana|
    reuniao_recorrente = Reuniao.new(
    titulo: "Reunião Semanal de Acompanhamento",
    descricao: "Reunião semanal para acompanhamento das atividades em andamento e alinhamento de prioridades.",
    data_inicio: data_atual + semana.weeks + 1.day + 14.hours,
    data_fim: data_atual + semana.weeks + 1.day + 15.hours,
    local_fisico: "Sede Principal - Fortaleza",
    sala: "Sala de Reunião 01 - Térreo",
    status: "agendada",
    organizador_id: organizadores.first.id
    )
    
    if reuniao_recorrente.save
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

  2.times do |mes|
    reuniao_mensal = Reuniao.new(
    titulo: "Reunião Mensal de Resultados",
    descricao: "Apresentação e análise dos resultados do mês anterior, definição de metas e estratégias para o próximo período.",
    data_inicio: data_atual + mes.months + 5.days + 10.hours,
    data_fim: data_atual + mes.months + 5.days + 12.hours,
    plataforma_virtual: "Microsoft Teams",
    link_reuniao: "https://teams.microsoft.com/meeting/#{SecureRandom.alphanumeric(12)}",
    status: "agendada",
    organizador_id: organizadores.last.id
    )
    
    if reuniao_mensal.save
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

  puts "\n=== Resumo da Operação ==="
  puts "Total processado: #{total_processado}"
  puts "Reuniões criadas com sucesso: #{sucessos}"
  puts "Reuniões com erro: #{erros}" if erros > 0
  puts "Tempo de execução: #{(Time.now - start_time).round}s"
  
  puts "\n=== Estatísticas Finais ==="
  puts "Total de reuniões no sistema: #{Reuniao.count}"
  puts "Total de participantes: #{Participante.count}"
rescue => e
  puts "\n Erro ao carregar usuários: #{e.message}"
  puts "Debug: #{e.backtrace.first}"
end
