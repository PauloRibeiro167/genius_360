puts "\nCriando propostas fictícias para testes..."

# Status possíveis para as propostas
status_propostas = [
  "Em análise",
  "Aprovada",
  "Reprovada",
  "Aguardando documentação",
  "Em negociação",
  "Finalizada",
  "Cancelada",
  "Pendente",
  "Em revisão"
]

# Prefixos para diferentes tipos de propostas
prefixos_propostas = [
  "COM-", # Comercial
  "CORP-", # Corporativo
  "INST-", # Institucional
  "VIP-", # Cliente VIP
  "GOV-", # Governamental
  "PRJ-"  # Projeto especial
]

# Função para gerar um número de proposta único
def gerar_numero_proposta(prefixo)
  ano = Time.now.year
  sequencia = rand(1000..9999)
  "#{prefixo}#{ano}-#{sequencia}"
end

# Criação de propostas fictícias
total_propostas = 50
propostas_criadas = 0

puts "Gerando #{total_propostas} propostas com status variados..."

total_propostas.times do |i|
  # Escolhe um prefixo aleatório para a proposta
  prefixo = prefixos_propostas.sample
  
  # Gera um número de proposta único
  numero = gerar_numero_proposta(prefixo)
  
  # Define o status da proposta
  status = status_propostas.sample
  
  # Cria a proposta no banco de dados
  proposta = Proposta.new(
    numero: numero,
    status: status
  )
  
  # Salva a proposta e contabiliza
  if proposta.save
    propostas_criadas += 1
    print "." if i % 5 == 0 # Imprime um ponto a cada 5 propostas para mostrar o progresso
  else
    puts "\nErro ao criar proposta #{numero}: #{proposta.errors.full_messages.join(', ')}"
  end
end

puts "\n#{propostas_criadas} propostas criadas com sucesso!"

# Cria algumas propostas com status específicos para testes
puts "\nCriando algumas propostas com status específicos para testes..."

# Propostas em análise (recentes)
3.times do |i|
  prefixo = prefixos_propostas.sample
  numero = gerar_numero_proposta(prefixo)
  
  proposta = Proposta.create(
    numero: numero,
    status: "Em análise"
  )
  
  puts "Proposta em análise criada: #{numero}" if proposta.persisted?
end

# Propostas aprovadas (para testes de fluxo)
5.times do |i|
  prefixo = prefixos_propostas.sample
  numero = gerar_numero_proposta(prefixo)
  
  proposta = Proposta.create(
    numero: numero,
    status: "Aprovada"
  )
  
  puts "Proposta aprovada criada: #{numero}" if proposta.persisted?
end

# Propostas pendentes (para testes de alerta)
2.times do |i|
  prefixo = prefixos_propostas.sample
  numero = gerar_numero_proposta(prefixo)
  
  proposta = Proposta.create(
    numero: numero,
    status: "Pendente"
  )
  
  puts "Proposta pendente criada: #{numero}" if proposta.persisted?
end

# Estatísticas finais
total_por_status = {}

status_propostas.each do |status|
  contagem = Proposta.where(status: status).count
  total_por_status[status] = contagem
end

puts "\nEstatísticas de propostas por status:"
total_por_status.each do |status, contagem|
  puts "  - #{status}: #{contagem} propostas"
end

puts "\nTotal de propostas criadas: #{Proposta.count}"

# Nota: você pode precisar corrigir o nome da tabela na migration se estiver usando "proposta" (singular) em vez de "propostas" (plural)
if Proposta.count == 0
  puts "\nATENÇÃO: Nenhuma proposta foi criada. Verifique se a tabela 'propostas' existe ou se o nome da tabela na migration está correto."
  puts "A migration atual está criando uma tabela chamada 'proposta' (singular), mas o padrão do Rails é usar o plural."
end