# filepath: /genius360/genius360/db/seeds/financial_transactions.rb
# Este arquivo é responsável por popular a tabela financial_transactions com dados de teste.

puts "Criando transações financeiras..."

# Criando registros de transações financeiras
FinancialTransaction.create([
  {
    tipo: "entrada",
    valor: 1000.00,
    descricao: "Venda de produto",
    categoria: "Vendas",
    data_competencia: Date.today,
    forma_pagamento: "Transferência",
    status: "confirmado",
    numero_documento: "DOC123456",
    user_id: User.first.id,
    conta_bancaria_id: ContaBancaria.first.id,
    centro_custo: "Vendas Gerais",
    observacoes: "Transação realizada com sucesso",
    numero_parcela: "1",
    reembolsavel: false
  },
  {
    tipo: "saida",
    valor: 200.00,
    descricao: "Compra de material",
    categoria: "Despesas",
    data_competencia: Date.today,
    forma_pagamento: "Cartão de Crédito",
    status: "pendente",
    numero_documento: "DOC654321",
    user_id: User.first.id,
    conta_bancaria_id: ContaBancaria.first.id,
    centro_custo: "Materiais",
    observacoes: "Aguardando pagamento",
    numero_parcela: "1",
    reembolsavel: true,
    status_reembolso: "pendente",
    data_solicitacao_reembolso: nil,
    justificativa_reembolso: nil,
    comprovante_reembolso_path: nil
  }
])

FinancialTransaction.create!(
  amount: 100.0,
  transaction_type: "credit",
  user_id: User.first.id
)

# Adicione mais transações conforme necessário