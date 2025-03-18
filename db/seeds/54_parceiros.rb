puts "Criando registros de parceiros para o programa de indicações..."

# Limpa registros existentes para evitar duplicações
# Parceiro.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários no sistema
usuarios = User.all
if usuarios.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

# Lista de bancos comuns
bancos = [
  "Banco do Brasil",
  "Itaú",
  "Bradesco", 
  "Santander", 
  "Caixa Econômica Federal",
  "Nubank", 
  "Inter",
  "C6 Bank",
  "BTG Pactual",
  "PicPay"
]

# Lista de tipos de PIX
tipos_pix = ["CPF", "E-mail", "Telefone", "Chave Aleatória"]

# Níveis de parceiros e suas comissões
niveis_parceiros = [
  {nivel: 1, nome: "Bronze", comissao: 2.0},  # 2.0% de comissão
  {nivel: 2, nome: "Prata", comissao: 3.0},   # 3.0% de comissão
  {nivel: 3, nome: "Ouro", comissao: 5.0},    # 5.0% de comissão
  {nivel: 4, nome: "Diamante", comissao: 8.0} # 8.0% de comissão
]

# Periodicidade de pagamento
periodicidades = ["quinzenal", "mensal", "bimestral"]

# Data atual para referência
data_atual = Date.today

# Contador de parceiros criados
parceiros_criados = 0
parceiros_inativos = 0

# Seleciona uma parte dos usuários para serem parceiros
usuarios_parceiros = usuarios.sample(usuarios.count / 3) # 1/3 dos usuários serão parceiros

puts "Gerando parceiros a partir de #{usuarios_parceiros.count} usuários selecionados..."

# Cria parceiros com dados mais completos
usuarios_parceiros.each do |usuario|
  # Informações de nível e comissão baseadas em um perfil aleatório ou distribuição
  nivel_idx = case rand(100)
              when 0..50 then 0   # 50% nível Bronze
              when 51..80 then 1  # 30% nível Prata
              when 81..95 then 2  # 15% nível Ouro
              else 3              # 5% nível Diamante
              end
  
  nivel = niveis_parceiros[nivel_idx]
  
  # Define se o parceiro está ativo ou não
  is_ativo = rand < 0.9 # 90% dos parceiros estão ativos
  
  # Gera código único para o parceiro (P + ID do usuário + 3 caracteres aleatórios)
  codigo = "P#{usuario.id}#{('A'..'Z').to_a.sample(3).join}"
  
  # Dados bancários
  banco_selecionado = bancos.sample
  tipo_pix = tipos_pix.sample
  
  # Seleciona a periodicidade de pagamento
  periodicidade = periodicidades.sample
  dia_pagamento = case periodicidade
                  when "quinzenal" then [5, 20].sample
                  when "mensal" then rand(1..10)
                  when "bimestral" then rand(1..5)
                  end
  
  # Define valor mínimo para pagamento
  valor_minimo = [0, 50, 100].sample
  
  # Define datas de aprovação e pagamentos
  data_aprovacao = is_ativo ? rand(30..365).days.ago : nil
  
  if is_ativo && data_aprovacao
    # Define o último pagamento (entre a data de aprovação e hoje)
    # Calcular a diferença em dias entre a data de aprovação e hoje
    dias_desde_aprovacao = (data_atual - data_aprovacao.to_date).to_i
    # Escolher um número aleatório de dias para adicionar à data de aprovação
    dias_aleatorios = rand(0..dias_desde_aprovacao)
    ultimo_pagamento = data_aprovacao.to_date + dias_aleatorios.days
    
    # Define o próximo pagamento com base na periodicidade
    dias_para_proximo = case periodicidade
                        when "quinzenal" then 15
                        when "mensal" then 30
                        when "bimestral" then 60
                        end
    proximo_pagamento = ultimo_pagamento + dias_para_proximo.days
  else
    ultimo_pagamento = nil
    proximo_pagamento = nil
  end
  
  # Total de indicações e conversões (valores fictícios)
  total_indicacoes = is_ativo ? rand(0..50) : rand(0..5)
  taxa_conversao = rand(0.2..0.6) # Taxa de conversão entre 20% e 60%
  indicacoes_convertidas = (total_indicacoes * taxa_conversao).to_i
  
  # Valor médio por conversão entre R$ 50 e R$ 200
  valor_medio_comissao = rand(50..200)
  valor_total_comissoes = indicacoes_convertidas * valor_medio_comissao
  
  # QR Code e URL (simulados)
  qrcode_path = "/uploads/parceiros/qrcodes/#{codigo}.png" if is_ativo
  url_indicacao = is_ativo ? "https://genius360.com.br/indicacao/#{codigo}" : nil
  
  # Observações personalizadas
  observacoes = if total_indicacoes > 20
                  "Parceiro de alto desempenho. Considerar upgrade para próximo nível."
                elsif total_indicacoes > 0
                  "Desempenho regular. Manter acompanhamento mensal."
                else
                  "Novo parceiro ou sem atividade. Verificar engajamento."
                end
  
  # Discarded_at para parceiros inativos
  discarded_at = is_ativo ? nil : rand(30..180).days.ago
  
  # Dados de contato (fictícios)
  email_titular = usuario.email # Usa o mesmo email do usuário
  telefone_titular = "(#{rand(11..99)}) #{rand(9)}#{rand(1000..9999)}-#{rand(1000..9999)}"
  
  # Cria o parceiro
  parceiro = Parceiro.new(
    user_id: usuario.id,  # Usar diretamente o ID do usuário
    percentual_comissao: nivel[:comissao],
    chave_pix: tipo_pix == "E-mail" ? email_titular : SecureRandom.uuid.first(20),
    banco: banco_selecionado,
    agencia: "#{rand(1000..9999)}",
    conta: "#{rand(10000..99999)}-#{rand(0..9)}",
    tipo_conta: ["corrente", "poupança"].sample,
    titular_conta: usuario.respond_to?(:nome) ? usuario.nome : "Titular #{codigo}",
    cpf_titular: "#{rand(100..999)}.#{rand(100..999)}.#{rand(100..999)}-#{rand(10..99)}",
    email_titular: email_titular,
    telefone_titular: telefone_titular,
    endereco_titular: "Rua #{('A'..'Z').to_a.sample} #{rand(1..999)}",
    cidade_titular: ["São Paulo", "Rio de Janeiro", "Belo Horizonte", "Brasília", "Salvador"].sample,
    estado_titular: ["SP", "RJ", "MG", "DF", "BA"].sample,
    cep_titular: "#{rand(10000..99999)}-#{rand(100..999)}",
    discarded_at: discarded_at,
    periodicidade_pagamento: periodicidade,
    dia_pagamento: dia_pagamento,
    valor_minimo_pagamento: valor_minimo,
    codigo_parceiro: codigo,
    qrcode_path: qrcode_path,
    url_indicacao: url_indicacao,
    ativo: is_ativo,
    nivel_parceiro: nivel[:nivel],
    observacoes: observacoes,
    total_indicacoes: total_indicacoes,
    indicacoes_convertidas: indicacoes_convertidas,
    valor_total_comissoes: valor_total_comissoes,
    data_aprovacao: data_aprovacao,
    proximo_pagamento: proximo_pagamento,
    ultimo_pagamento: ultimo_pagamento
  )
  
  if parceiro.save
    parceiros_criados += 1
    parceiros_inativos += 1 unless is_ativo
    
    status = is_ativo ? "[ATIVO]" : "[INATIVO]"
    puts "Parceiro criado: #{codigo} - Nível #{nivel[:nome]} - #{total_indicacoes} indicações #{status}"
  else
    puts "ERRO ao criar parceiro para #{usuario.email}: #{parceiro.errors.full_messages.join(', ')}"
  end
end

# Cria alguns parceiros de destaque com histórico expressivo
if parceiros_criados > 0
  # Seleciona alguns usuários que ainda não são parceiros
  usuarios_destaque = usuarios.reject { |u| usuarios_parceiros.include?(u) }.sample(3)
  
  usuarios_destaque.each_with_index do |usuario, idx|
    codigo = "PVIP#{usuario.id}"
    nivel = niveis_parceiros.last # Nível mais alto (Diamante)
    
    # Estatísticas impressionantes
    total_indicacoes = rand(100..300)
    indicacoes_convertidas = (total_indicacoes * rand(0.5..0.8)).to_i
    valor_total_comissoes = indicacoes_convertidas * rand(200..500)
    
    parceiro_destaque = Parceiro.create!(
      user_id: usuario.id,  # Usar diretamente o ID do usuário
      # outros atributos permanecem iguais
      percentual_comissao: nivel[:comissao],
      chave_pix: usuario.email,
      banco: bancos.sample,
      agencia: "#{rand(1000..9999)}",
      conta: "#{rand(10000..99999)}-#{rand(0..9)}",
      tipo_conta: "corrente",
      titular_conta: usuario.respond_to?(:nome) ? usuario.nome : "Parceiro VIP #{idx+1}",
      cpf_titular: "#{rand(100..999)}.#{rand(100..999)}.#{rand(100..999)}-#{rand(10..99)}",
      email_titular: usuario.email,
      telefone_titular: "(#{rand(11..99)}) #{rand(9)}#{rand(1000..9999)}-#{rand(1000..9999)}",
      periodicidade_pagamento: "mensal",
      dia_pagamento: 5,
      valor_minimo_pagamento: 0,
      codigo_parceiro: codigo,
      qrcode_path: "/uploads/parceiros/qrcodes/vip/#{codigo}.png",
      url_indicacao: "https://genius360.com.br/parceiro-vip/#{codigo}",
      ativo: true,
      nivel_parceiro: nivel[:nivel],
      observacoes: "Parceiro VIP com histórico excepcional de indicações. Prioridade máxima.",
      total_indicacoes: total_indicacoes,
      indicacoes_convertidas: indicacoes_convertidas,
      valor_total_comissoes: valor_total_comissoes,
      data_aprovacao: 1.year.ago,
      proximo_pagamento: Date.today + 15.days,
      ultimo_pagamento: Date.today - 15.days
    )
    
    parceiros_criados += 1
    puts "Parceiro VIP criado: #{codigo} - #{total_indicacoes} indicações (#{indicacoes_convertidas} conversões)"
  end
end

# Estatísticas gerais
puts "\nEstatísticas gerais:"
puts "- Total de parceiros criados: #{parceiros_criados}"
puts "- Parceiros ativos: #{parceiros_criados - parceiros_inativos}"
puts "- Parceiros inativos: #{parceiros_inativos}"

# Distribuição por nível
niveis_parceiros.each do |nivel_info|
  count = Parceiro.where(nivel_parceiro: nivel_info[:nivel]).count
  percentage = parceiros_criados > 0 ? (count.to_f / parceiros_criados * 100).round(1) : 0
  puts "- Nível #{nivel_info[:nome]}: #{count} parceiros (#{percentage}%)"
end

# Total de indicações e valores
total_indicacoes = Parceiro.sum(:total_indicacoes)
total_convertidas = Parceiro.sum(:indicacoes_convertidas)
valor_total = Parceiro.sum(:valor_total_comissoes)
taxa_conversao_geral = total_convertidas.to_f / total_indicacoes * 100 rescue 0

puts "\nIndicações e conversões:"
puts "- Total de indicações: #{total_indicacoes}"
puts "- Total de conversões: #{total_convertidas}"
puts "- Taxa média de conversão: #{taxa_conversao_geral.round(1)}%"
puts "- Valor total de comissões: R$ #{valor_total}"

puts "\nRegistros de parceiros criados com sucesso!"