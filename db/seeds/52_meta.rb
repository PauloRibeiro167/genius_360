puts "Criando registros de metas para demonstração..."

# Limpa registros existentes para evitar duplicações
# Meta.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários no sistema
users = User.all
if users.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  puts "Não é possível criar metas sem usuários."
  exit
end

# Tipos de metas que podem ser cadastradas
tipos_metas = [
  "Vendas Mensais",
  "Captação de Clientes",
  "Empréstimos Consignados",
  "Cartões Consignados",
  "Refinanciamentos",
  "Portabilidade",
  "Captação de Leads",
  "Conversão de Propostas",
  "Retenção de Clientes",
  "Satisfação do Cliente"
]

# Status possíveis para as metas (CORRIGIDO)
status_metas = [
  "em andamento",
  "concluida",
  "nao_atingida",  # Modificado: underscore em vez de espaço
  "superada",
  "cancelada"
]

# Mês atual e próximos meses para datas das metas
data_atual = Date.today
mes_atual = data_atual.beginning_of_month
proximo_mes = mes_atual.next_month
trimestre = mes_atual + 3.months
semestre = mes_atual + 6.months

# Número de metas a serem criadas
metas_criadas = 0
total_metas = users.count * 3 # 3 metas por usuário

puts "Gerando #{total_metas} metas para #{users.count} usuários..."

# Cria metas para cada usuário
users.each do |user|
  # 1. Meta do mês atual (em andamento)
  meta_mensal = Meta.create!(
    user_id: user.id,
    tipo_meta: "Vendas Mensais",
    valor_meta: rand(50000..150000), # Meta entre 50.000 e 150.000
    data_inicio: mes_atual,
    data_fim: mes_atual.end_of_month,
    status: "em andamento",
    observacoes: "Meta mensal padrão. Acompanhamento semanal.",
    modified_at: Time.now
  )
  metas_criadas += 1
  
  # 2. Meta do próximo mês (planejada)
  meta_proximo = Meta.create!(
    user_id: user.id,
    tipo_meta: tipos_metas.sample,
    valor_meta: rand(60000..200000), # Meta entre 60.000 e 200.000
    data_inicio: proximo_mes,
    data_fim: proximo_mes.end_of_month,
    status: "em andamento",
    observacoes: "Meta para o próximo mês, baseada na performance atual.",
    modified_at: Time.now
  )
  metas_criadas += 1
  
  # 3. Meta de trimestre ou semestre (longo prazo)
  prazo_longo = [trimestre, semestre].sample
  meta_longo_prazo = Meta.create!(
    user_id: user.id,
    tipo_meta: "Captação de Clientes",
    valor_meta: rand(300..1000), # Meta de 300 a 1000 novos clientes
    data_inicio: mes_atual,
    data_fim: prazo_longo.end_of_month,
    status: "em andamento",
    observacoes: "Meta de longo prazo para expansão da carteira de clientes.",
    modified_at: Time.now
  )
  metas_criadas += 1
end

# Cria algumas metas concluídas (históricas)
3.times do |i|
  mes_passado = mes_atual - (i+1).months
  status_historico = ["concluida", "nao_atingida", "superada"].sample
  
  # Seleciona usuários aleatórios para metas históricas
  usuario_aleatorio = users.sample
  
  meta_historica = Meta.create!(
    user_id: usuario_aleatorio.id,
    tipo_meta: tipos_metas.sample,
    valor_meta: rand(40000..100000),
    data_inicio: mes_passado.beginning_of_month,
    data_fim: mes_passado.end_of_month,
    status: status_historico,
    observacoes: "Meta histórica do mês de #{I18n.l(mes_passado, format: '%B/%Y')}. Status final: #{status_historico}.",
    modified_at: mes_passado.end_of_month
  )
  metas_criadas += 1
end

# Cria meta para equipe (administrador)
admin = User.find_by(admin: true)
if admin
  meta_equipe = Meta.create!(
    user_id: admin.id,
    tipo_meta: "Meta de Equipe - Vendas Totais",
    valor_meta: 500000, # Meta de R$ 500.000
    data_inicio: mes_atual,
    data_fim: trimestre,
    status: "em andamento",
    observacoes: "Meta trimestral para toda a equipe. Premiação especial para quem atingir 120% da meta individual.",
    modified_at: Time.now
  )
  metas_criadas += 1
  
  # Meta descartada/cancelada para exemplo de soft delete
  meta_cancelada = Meta.create!(
    user_id: admin.id,
    tipo_meta: "Promoção Especial",
    valor_meta: 200000,
    data_inicio: mes_atual - 1.month,
    data_fim: mes_atual + 2.months,
    status: "cancelada",
    observacoes: "Meta cancelada devido a mudanças nas condições de mercado.",
    discarded_at: Time.now - 5.days,
    modified_at: Time.now - 5.days
  )
  metas_criadas += 1
end

puts "Total de metas criadas: #{metas_criadas}"
puts "Metas criadas com sucesso!"