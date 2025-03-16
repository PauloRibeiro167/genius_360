puts "Criando relações entre taxas de consignados e benefícios..."

# Limpa registros existentes para evitar duplicações
# TaxaBeneficio.destroy_all (descomente se quiser limpar a tabela antes)

# Obtém os IDs existentes para criar relações válidas
taxas_consignados = TaxaConsignado.all.index_by(&:nome)
beneficios = Beneficio.all.index_by(&:codigo)

# Se não houver taxas ou benefícios cadastrados, exibe um aviso
if taxas_consignados.empty? || beneficios.empty?
  puts "ATENÇÃO: É necessário ter taxas de consignados e benefícios cadastrados antes de executar esta seed."
  puts "Execute primeiro as seeds de taxas_consignados.rb e beneficios.rb"
  exit
end

# Array de relações entre taxas e benefícios
relacoes = [
  {
    taxa_consignado: "Empréstimo Consignado INSS",
    beneficio: "01", # Aposentadoria por idade
    aplicavel: true,
    regras_especiais: "Limite de crédito calculado com base no histórico de benefícios"
  },
  {
    taxa_consignado: "Empréstimo Consignado INSS",
    beneficio: "04", # Aposentadoria por invalidez
    aplicavel: true,
    regras_especiais: "Requer documentação médica adicional"
  },
  {
    taxa_consignado: "Empréstimo Consignado INSS",
    beneficio: "21", # Pensão por morte
    aplicavel: true,
    regras_especiais: nil
  },
  {
    taxa_consignado: "Empréstimo Consignado INSS",
    beneficio: "87", # Amparo ao portador de deficiência
    aplicavel: false,
    regras_especiais: "Não aplicável conforme regulamentação vigente"
  },
  {
    taxa_consignado: "Empréstimo Consignado para Servidores Públicos Federais",
    beneficio: "01", # Aposentadoria por idade
    aplicavel: true,
    regras_especiais: "Taxa preferencial para servidores com mais de 10 anos de carreira"
  },
  {
    taxa_consignado: "Cartão Consignado - INSS",
    beneficio: "01", # Aposentadoria por idade
    aplicavel: true,
    regras_especiais: "Limite de cartão de até 5% do benefício mensal"
  },
  {
    taxa_consignado: "Cartão Consignado - INSS",
    beneficio: "04", # Aposentadoria por invalidez
    aplicavel: true,
    regras_especiais: "Limite de cartão de até 5% do benefício mensal"
  },
  {
    taxa_consignado: "Refinanciamento Consignado - Padrão",
    beneficio: "01", # Aposentadoria por idade
    aplicavel: true,
    regras_especiais: "Permitido após quitação de 25% do contrato original"
  },
  {
    taxa_consignado: "Portabilidade Consignado - INSS",
    beneficio: "01", # Aposentadoria por idade
    aplicavel: true,
    regras_especiais: "Disponível para contratos com mais de 3 parcelas pagas"
  },
  {
    taxa_consignado: "Taxa Especial Promocional - Servidor Público",
    beneficio: "01", # Aposentadoria por idade (para servidor aposentado)
    aplicavel: true,
    regras_especiais: "Oferta por tempo limitado, sujeita à análise de crédito"
  }
]

# Cria as relações
relacoes.each do |rel|
  # Busca os registros de taxa e benefício pelos nomes/códigos
  taxa = taxas_consignados[rel[:taxa_consignado]]
  beneficio = beneficios[rel[:beneficio]]
  
  # Pula se não encontrar taxa ou benefício
  unless taxa && beneficio
    puts "AVISO: Não foi possível encontrar taxa '#{rel[:taxa_consignado]}' ou benefício '#{rel[:beneficio]}'"
    next
  end
  
  # Cria ou atualiza o registro
  taxa_beneficio = TaxaBeneficio.find_or_initialize_by(
    taxa_consignado_id: taxa.id,
    beneficio_id: beneficio.id
  )
  
  taxa_beneficio.update!(
    aplicavel: rel[:aplicavel],
    regras_especiais: rel[:regras_especiais],
    ativo: true
  )
  
  puts "Criada relação: #{rel[:taxa_consignado]} + #{rel[:beneficio]}"
end

# Criando um registro inativo para demonstração
if taxas_consignados["Taxa Antiga Inativa - INSS"] && beneficios["01"]
  taxa_inativa = taxas_consignados["Taxa Antiga Inativa - INSS"]
  beneficio = beneficios["01"]
  
  TaxaBeneficio.create!(
    taxa_consignado_id: taxa_inativa.id,
    beneficio_id: beneficio.id,
    aplicavel: false,
    regras_especiais: "Relação inativa - taxa descontinuada",
    ativo: false,
    discarded_at: Date.today - 30.days
  )
  
  puts "Criada relação inativa para demonstração"
end

puts "Relações entre taxas e benefícios criadas com sucesso! Total: #{TaxaBeneficio.count}"