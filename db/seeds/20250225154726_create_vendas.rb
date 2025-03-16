puts "Criando registros de vendas para demonstração..."

# Limpa registros existentes para evitar duplicações
# Venda.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários, clientes, leads e parceiros no sistema
usuarios = User.all
clientes = defined?(Cliente) ? Cliente.all : []
leads = defined?(Lead) ? Lead.all : []
parceiros = defined?(Parceiro) ? Parceiro.all : []

if usuarios.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

if clientes.empty?
  puts "ATENÇÃO: Não existem clientes cadastrados. Execute primeiro a seed de clientes."
  exit
end

if leads.empty?
  puts "ATENÇÃO: Não existem leads cadastrados. Execute primeiro a seed de leads."
  exit
end

if parceiros.empty?
  puts "ATENÇÃO: Não existem parceiros cadastrados. Execute primeiro a seed de parceiros."
  exit
end

# Período para as vendas
data_inicial = 1.year.ago
data_final = Date.today

# Contador de vendas criadas
vendas_criadas = 0
total_vendas = 200 # Número de vendas a serem criadas

puts "Gerando #{total_vendas} registros de vendas..."

# Gera vendas distribuídas ao longo do período
total_vendas.times do |i|
  # Seleciona entidades aleatórias para a venda
  usuario = usuarios.sample
  cliente = clientes.sample
  lead = leads.sample
  parceiro = i % 5 == 0 ? parceiros.sample : nil # 20% das vendas têm parceiro
  
  # Define datas (data_venda sempre antes de data_contratação)
  data_venda = rand(data_inicial..data_final)
  dias_ate_contratacao = rand(1..30) # De 1 a 30 dias para contratar
  data_contratacao = data_venda + dias_ate_contratacao.days
  
  # Define se é uma indicação
  indicacao = parceiro.present?
  
  # Define valor da venda (entre R$ 5.000 e R$ 50.000)
  valor_venda = rand(5000..50000)
  
  # Cria a venda
  venda = Venda.new(
    lead_id: lead.id,
    cliente_id: cliente.id,
    user_id: usuario.id,
    valor_venda: valor_venda,
    data_venda: data_venda,
    data_contratacao: data_contratacao,
    indicacao: indicacao,
    parceiro_id: parceiro&.id
  )
  
  if venda.save
    vendas_criadas += 1
    
    # Mostra progresso a cada 20 vendas
    if (vendas_criadas % 20).zero?
      puts "... #{vendas_criadas} vendas criadas"
    end
  else
    puts "ERRO ao criar venda: #{venda.errors.full_messages.join(', ')}"
  end
end

# Cria algumas vendas especiais para análise
# Vendas de alto valor
3.times do
  usuario_top = usuarios.sample
  cliente_top = clientes.sample
  lead_top = leads.sample
  
  data_venda = rand(3.months.ago..Date.today)
  data_contratacao = data_venda + rand(2..10).days
  
  venda_premium = Venda.create!(
    lead_id: lead_top.id,
    cliente_id: cliente_top.id,
    user_id: usuario_top.id,
    valor_venda: rand(80000..120000), # Valor elevado
    data_venda: data_venda,
    data_contratacao: data_contratacao,
    indicacao: false,
    parceiro_id: nil
  )
  
  vendas_criadas += 1
  puts "Venda premium criada: R$ #{venda_premium.valor_venda} - Cliente: #{cliente_top.nome}" if defined?(cliente_top.nome)
end

# Vendas com indicação de parceiros (comissionadas)
5.times do
  usuario = usuarios.sample
  cliente = clientes.sample
  lead = leads.sample
  parceiro = parceiros.sample
  
  data_venda = rand(6.months.ago..Date.today)
  data_contratacao = data_venda + rand(1..15).days
  
  venda_indicada = Venda.create!(
    lead_id: lead.id,
    cliente_id: cliente.id,
    user_id: usuario.id,
    valor_venda: rand(15000..40000),
    data_venda: data_venda,
    data_contratacao: data_contratacao,
    indicacao: true,
    parceiro_id: parceiro.id
  )
  
  vendas_criadas += 1
  puts "Venda por indicação criada: R$ #{venda_indicada.valor_venda} - Parceiro: #{parceiro.nome}" if defined?(parceiro.nome)
end

# Calcula estatísticas das vendas
total_valor = Venda.sum(:valor_venda)
media_valor = Venda.average(:valor_venda).to_f
maior_venda = Venda.maximum(:valor_venda)
menor_venda = Venda.minimum(:valor_venda)
vendas_indicacao = Venda.where(indicacao: true).count

puts "\nEstatísticas gerais:"
puts "- Total de vendas criadas: #{vendas_criadas}"
puts "- Valor total das vendas: R$ #{total_valor}"
puts "- Valor médio por venda: R$ #{media_valor.round(2)}"
puts "- Maior venda: R$ #{maior_venda}"
puts "- Menor venda: R$ #{menor_venda}"
puts "- Vendas por indicação: #{vendas_indicacao} (#{(vendas_indicacao.to_f / vendas_criadas * 100).round(1)}%)"

# Vendas por período
puts "\nVendas por período:"
meses = (0..11).map { |i| (Date.today - i.months).beginning_of_month }

meses.each do |mes|
  inicio_mes = mes.beginning_of_month
  fim_mes = mes.end_of_month
  vendas_mes = Venda.where(data_venda: inicio_mes..fim_mes)
  
  if vendas_mes.any?
    puts "- #{I18n.l(mes, format: '%B/%Y')}: #{vendas_mes.count} vendas, total: R$ #{vendas_mes.sum(:valor_venda)}"
  end
end

puts "\nRegistros de vendas criados com sucesso!"