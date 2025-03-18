puts "Criando registros de acompanhamentos de leads para demonstração..."

leads = defined?(Lead) ? Lead.all : []
usuarios = User.all

if leads.empty?
  puts "ATENÇÃO: Não existem leads cadastrados. Execute primeiro a seed de leads."
  exit
end

if usuarios.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

tipos_acompanhamento = [
  "Ligação telefônica",
  "E-mail",
  "WhatsApp",
  "Reunião virtual",
  "Visita presencial",
  "SMS",
  "Redes sociais"
]

status = [
  "Pendente",
  "Concluído",
  "Remarcado",
  "Cancelado",
  "Convertido em venda"
]

resultados = [
  "Cliente interessado, solicitou mais informações",
  "Cliente solicitou contato em outro momento",
  "Cliente não atendeu",
  "Cliente não demonstrou interesse",
  "Cliente pediu proposta formal",
  "Cliente comparou com concorrência",
  "Cliente em dúvida sobre valores",
  "Cliente convertido em venda",
  "Deixado recado",
  "Mensagem enviada, aguardando retorno",
  "E-mail enviado com detalhes do serviço",
  "Proposta enviada, aguardando feedback",
  "Reunião agendada para apresentação",
  "Cliente precisou remarcar"
]

data_inicial = 6.months.ago.to_date
data_final = Date.today + 2.weeks

acompanhamentos_criados = 0
total_acompanhamentos = 500

puts "Gerando #{total_acompanhamentos} registros de acompanhamentos..."

dias_totais = (data_final - data_inicial).to_i

leads.each do |lead|
  qtd_acompanhamentos = rand(1..5)
  
  usuario_responsavel = usuarios.sample
  
  datas = []
  qtd_acompanhamentos.times do
    dias_aleatorios = rand(0..dias_totais)
    datas << data_inicial + dias_aleatorios
  end
  datas.sort!
  
  ultimo_status = nil
  
  datas.each_with_index do |data, idx|
    if data > Date.today
      status_atual = "Pendente"
    elsif idx == datas.size - 1
      status_atual = ["Concluído", "Convertido em venda", "Pendente"].sample
    else
      status_atual = ["Concluído", "Remarcado", "Concluído", "Cancelado"].sample
    end
    
    proxima_data = nil
    if status_atual == "Remarcado" || status_atual == "Pendente"
      proxima_data = data + rand(2..10).days
    end
    
    if status_atual == "Pendente"
      prioridade = rand(1..3)
    else
      prioridade = nil
    end
    
    if status_atual == "Pendente"
      duracao = [15, 30, 45, 60].sample
    else
      duracao = rand(5..90)
    end
    
    if status_atual == "Pendente"
      resultado = nil
    elsif status_atual == "Convertido em venda"
      resultado = "Cliente convertido em venda"
    elsif status_atual == "Cancelado"
      resultado = "Cliente não demonstrou interesse"
    else
      resultado = resultados.sample
    end
    
    tipo = rand < 0.6 ? "Ligação telefônica" : tipos_acompanhamento.sample
    
    acompanhamento = Acompanhamento.create!(
      lead_id: lead.id,
      data_acompanhamento: data,
      resultado: resultado,
      tipo_acompanhamento: tipo,
      user_id: usuario_responsavel.id,
      status: status_atual,
      proxima_data: proxima_data,
      prioridade: prioridade,
      duracao_minutos: duracao
    )
    
    acompanhamentos_criados += 1
    ultimo_status = status_atual
    
    if (acompanhamentos_criados % 50).zero?
      puts "... #{acompanhamentos_criados} acompanhamentos criados"
    end
    
    break if acompanhamentos_criados >= total_acompanhamentos
  end
  
  break if acompanhamentos_criados >= total_acompanhamentos
end

pending_count = Acompanhamento.where(status: "Pendente").count
completed_count = Acompanhamento.where(status: "Concluído").count
rescheduled_count = Acompanhamento.where(status: "Remarcado").count
canceled_count = Acompanhamento.where(status: "Cancelado").count
converted_count = Acompanhamento.where(status: "Convertido em venda").count

puts "\nEstatísticas gerais:"
puts "- Total de acompanhamentos criados: #{acompanhamentos_criados}"
puts "- Pendentes: #{pending_count} (#{(pending_count.to_f / acompanhamentos_criados * 100).round(1)}%)"
puts "- Concluídos: #{completed_count} (#{(completed_count.to_f / acompanhamentos_criados * 100).round(1)}%)"
puts "- Remarcados: #{rescheduled_count} (#{(rescheduled_count.to_f / acompanhamentos_criados * 100).round(1)}%)"
puts "- Cancelados: #{canceled_count} (#{(canceled_count.to_f / acompanhamentos_criados * 100).round(1)}%)"
puts "- Convertidos em venda: #{converted_count} (#{(converted_count.to_f / acompanhamentos_criados * 100).round(1)}%)"

puts "\nAcompanhamentos por tipo:"
tipos_acompanhamento.each do |tipo|
  count = Acompanhamento.where(tipo_acompanhamento: tipo).count
  puts "- #{tipo}: #{count}" if count > 0
end

puts "\nAcompanhamentos por período:"
meses = (0..5).map { |i| (Date.today - i.months).beginning_of_month }

meses.each do |mes|
  inicio_mes = mes.beginning_of_month
  fim_mes = mes.end_of_month
  count = Acompanhamento.where(data_acompanhamento: inicio_mes..fim_mes).count
  
  if count > 0
    puts "- #{I18n.l(mes, format: '%B/%Y')}: #{count} acompanhamentos"
  end
end

puts "\nRegistros de acompanhamentos criados com sucesso!"
