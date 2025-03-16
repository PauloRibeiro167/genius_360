puts "Criando taxas de consignados..."

# Limpa registros existentes para evitar duplicações
# TaxaConsignado.destroy_all (descomente se quiser limpar a tabela antes)

# Array de operações de consignado comuns
tipos_operacoes = ["Empréstimo", "Cartão", "Refinanciamento", "Portabilidade"]

# Data de hoje para vigência
data_hoje = Date.today

# Taxas para empréstimos
# Nota: Taxa mínima de retirada de empréstimo é de 36 reais
[
  {
    nome: "Empréstimo Consignado INSS",
    taxa_minima: 1.680,
    taxa_maxima: 1.800,
    prazo_minimo: 12,
    prazo_maximo: 84,
    margem_emprestimo: 35.00,
    margem_cartao: 5.00,
    tipo_operacao: "Empréstimo",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: nil,
    ativo: true
  },
  {
    nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_minima: 1.550,
    taxa_maxima: 1.800,
    prazo_minimo: 12,
    prazo_maximo: 96,
    margem_emprestimo: 30.00,
    margem_cartao: 5.00,
    tipo_operacao: "Empréstimo",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: nil,
    ativo: true
  },
  {
    nome: "Empréstimo Consignado para Funcionários Privados",
    taxa_minima: 1.700,
    taxa_maxima: 3.000,
    prazo_minimo: 12,
    prazo_maximo: 48,
    margem_emprestimo: 30.00,
    margem_cartao: 5.00,
    tipo_operacao: "Empréstimo",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: nil,
    ativo: true
  },
  {
    nome: "Cartão Consignado - INSS",
    taxa_minima: 2.300,
    taxa_maxima: 2.830,
    prazo_minimo: 1,
    prazo_maximo: nil,
    margem_emprestimo: nil,
    margem_cartao: 5.00,
    tipo_operacao: "Cartão",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: nil,
    ativo: true
  },
  {
    nome: "Refinanciamento Consignado - Padrão",
    taxa_minima: 1.550,
    taxa_maxima: 1.900,
    prazo_minimo: 24,
    prazo_maximo: 96,
    margem_emprestimo: 35.00,
    margem_cartao: nil,
    tipo_operacao: "Refinanciamento",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: nil,
    ativo: true
  },
  {
    nome: "Portabilidade Consignado - INSS",
    taxa_minima: 1.450,
    taxa_maxima: 1.780,
    prazo_minimo: 12,
    prazo_maximo: 84,
    margem_emprestimo: 35.00,
    margem_cartao: nil,
    tipo_operacao: "Portabilidade",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: nil,
    ativo: true
  },
  {
    nome: "Taxa Especial Promocional - Servidor Público",
    taxa_minima: 1.400,
    taxa_maxima: 1.650,
    prazo_minimo: 12,
    prazo_maximo: 60,
    margem_emprestimo: 30.00,
    margem_cartao: nil,
    tipo_operacao: "Empréstimo",
    data_vigencia_inicio: data_hoje,
    data_vigencia_fim: data_hoje + 90.days, # Promoção de 90 dias
    ativo: true
  },
  {
    nome: "Taxa Antiga Inativa - INSS",
    taxa_minima: 1.660,
    taxa_maxima: 1.960,
    prazo_minimo: 12,
    prazo_maximo: 72,
    margem_emprestimo: 35.00,
    margem_cartao: nil,
    tipo_operacao: "Empréstimo",
    data_vigencia_inicio: data_hoje - 365.days,
    data_vigencia_fim: data_hoje - 30.days,
    ativo: false,
    discarded_at: data_hoje - 30.days
  }
].each do |taxa_attrs|
  taxa = TaxaConsignado.find_or_initialize_by(nome: taxa_attrs[:nome])
  taxa.assign_attributes(taxa_attrs)
  taxa.save!
end

puts "Taxas de consignados criadas com sucesso! Total: #{TaxaConsignado.count}"