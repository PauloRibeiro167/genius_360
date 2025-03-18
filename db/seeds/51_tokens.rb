puts "Criando registros de acesso para demonstração..."

users = User.all
if users.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  puts "Criando apenas registros de acesso sem usuário associado."
end

dispositivos = [
  "iPhone 14 Pro",
  "Samsung Galaxy S23",
  "iPhone 13",
  "Xiaomi Redmi Note 12",
  "Samsung Galaxy A54",
  "Motorola Moto G72",
  "MacBook Pro",
  "Dell XPS 13",
  "iPad Air",
  "Windows Desktop"
]

ips = [
  "187.45.123.45",
  "200.147.89.123",
  "189.75.34.212",
  "177.154.23.78",
  "201.33.65.198",
  "192.168.0.1",
  "10.0.0.15",
  "186.221.45.67",
  "179.124.236.54",
  "45.188.73.124"
]

descricoes = [
  "Login no sistema",
  "Acesso ao módulo de consignados",
  "Consulta de taxas",
  "Geração de relatório",
  "Visualização de propostas",
  "Atualização de cadastro",
  "Login via aplicativo móvel",
  "Tentativa de login inválida",
  "Logout do sistema",
  "Recuperação de senha"
]

data_inicial = 30.days.ago
data_final = Time.now

quantidade = 150
registros_criados = 0

puts "Gerando #{quantidade} registros de acesso..."

quantidade.times do
  user = users.sample if users.present? && rand < 0.9
  
  acesso = Acesso.new(
    user_id: user&.id,
    descricao: descricoes.sample,
    data_acesso: rand(data_inicial..data_final),
    ip: ips.sample,
    modelo_dispositivo: dispositivos.sample
  )
  
  if acesso.save
    registros_criados += 1
    if (registros_criados % 25).zero?
      puts "... criados #{registros_criados} registros"
    end
  else
    puts "Erro ao criar registro de acesso: #{acesso.errors.full_messages.join(', ')}"
  end
end

if users.present?
  user_demo = users.first
  
  (1..7).each do |dias_atras|
    Acesso.create!(
      user_id: user_demo.id,
      descricao: "Login diário",
      data_acesso: dias_atras.days.ago.change(hour: 8 + rand(0..1), min: rand(0..59)),
      ip: "187.45.123.45",
      modelo_dispositivo: "MacBook Pro"
    )
    
    Acesso.create!(
      user_id: user_demo.id,
      descricao: "Logout do sistema",
      data_acesso: dias_atras.days.ago.change(hour: 17 + rand(0..1), min: rand(0..59)),
      ip: "187.45.123.45",
      modelo_dispositivo: "MacBook Pro"
    )
  end
  
  puts "Criados registros de padrão de acesso para usuário de demonstração"
end

puts "Total de registros de acesso criados: #{registros_criados}"
puts "Registros de acesso criados com sucesso!"
