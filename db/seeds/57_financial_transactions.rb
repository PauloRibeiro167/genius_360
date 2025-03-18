# filepath: /genius360/genius360/db/seeds/financial_transactions.rb
# Este arquivo é responsável por popular a tabela financial_transactions com dados de teste.

puts "Criando transações financeiras..."

# Verifica se existem usuários
if User.count == 0
  puts "ERRO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

# Criando registros de transações financeiras
FinancialTransaction.create!([
  {
    tipo: "entrada",
    valor: 1000.00,
    descricao: "Venda de produto",
    categoria: "Vendas",
    data_competencia: Date.today,
    forma_pagamento: "Transferência",
    status: "pago", # Corrigido de "confirmado" para "pago"
    numero_documento: "DOC123456",
    user_id: User.first.id,
    conta_bancaria: "Conta Principal", # Corrigido de conta_bancaria_id para conta_bancaria
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
    conta_bancaria: "Conta Secundária", # Corrigido de conta_bancaria_id para conta_bancaria
    centro_custo: "Materiais",
    observacoes: "Aguardando pagamento",
    numero_parcela: "1",
    reembolsavel: true,
    status_reembolso: "solicitado", # Corrigido para um valor válido conforme enum
    data_solicitacao_reembolso: Date.today,
    justificativa_reembolso: "Despesa pessoal para cliente",
    comprovante_reembolso_path: nil
  }
])

puts "Transações financeiras criadas com sucesso!"
puts "Total de transações: #{FinancialTransaction.count}"
puts "Entradas: #{FinancialTransaction.entradas.count}"
puts "Saídas: #{FinancialTransaction.saidas.count}"