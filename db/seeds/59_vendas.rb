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

# Períodos para vendas
data_inicial = 1.year.ago.to_date
data_final = Date.today

# Número de vendas a serem criadas
vendas_criadas = 0
total_vendas = 200

puts "Criando registros de vendas para demonstração..."
puts "Gerando #{total_vendas} registros de vendas..."

# Verificando se existem leads e clientes suficientes
if Lead.count < 50
  puts "ALERTA: Você tem poucos leads cadastrados. Considere executar o seed de leads primeiro."
end

if Cliente.count < 50
  puts "ALERTA: Você tem poucos clientes cadastrados. Considere executar o seed de clientes primeiro."
end

# Obtendo usuários (vendedores)
usuarios = User.all
if usuarios.empty?
  puts "ERRO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

# Criando vendas
total_vendas.times do
  lead = Lead.order("RANDOM()").first
  cliente = Cliente.order("RANDOM()").first
  user = usuarios.sample
  
  # Gerando uma data aleatória dentro do período
  days_diff = (data_final - data_inicial).to_i
  random_days = rand(0..days_diff)
  data_venda = data_inicial + random_days.days
  
  # Data de contratação pode ser igual ou posterior à data da venda
  dias_ate_contratacao = rand(0..30)
  data_contratacao = data_venda + dias_ate_contratacao.days
  
  # Valores aleatórios para a venda
  valor = rand(1000..50000)
  
  # 20% das vendas são por indicação
  indicacao = rand(100) < 20
  
  # Se for indicação, busca um parceiro
  parceiro = nil
  parceiro = Parceiro.order("RANDOM()").first if indicacao
  
  venda = Venda.new(
    lead: lead,
    cliente: cliente,
    user: user,
    valor_venda: valor,
    data_venda: data_venda,
    data_contratacao: data_contratacao,
    indicacao: indicacao,
    parceiro: parceiro
  )
  
  if venda.save
    vendas_criadas += 1
  else
    puts "ERRO ao criar venda: #{venda.errors.full_messages.join(', ')}"
  end
end

# Estatísticas
puts "\nEstatísticas de vendas criadas:"
puts "- Total de vendas: #{vendas_criadas}"
puts "- Valor total: R$ #{Venda.sum(:valor_venda).round(2)}"
puts "- Média por venda: R$ #{(Venda.sum(:valor_venda) / Venda.count).round(2)}"
puts "- Vendas por indicação: #{Venda.where(indicacao: true).count} (#{(Venda.where(indicacao: true).count.to_f / Venda.count * 100).round(1)}%)"

# Vendas por mês
puts "\nVendas por mês:"
meses = (0..11).map { |i| (Date.today - i.months).beginning_of_month }

meses.each do |mes|
  inicio_mes = mes.beginning_of_month
  fim_mes = mes.end_of_month
  count = Venda.where(data_venda: inicio_mes..fim_mes).count
  
  if count > 0
    valor_mes = Venda.where(data_venda: inicio_mes..fim_mes).sum(:valor_venda)
    puts "- #{mes.strftime('%B/%Y')}: #{count} vendas (R$ #{valor_mes.round(2)})"
  end
end

puts "\nRegistros de vendas criados com sucesso!"