puts "Criando contas bancárias..."

ContaBancaria.create!(
  bank_name: "Banco Exemplo",
  account_number: "123456",
  user_id: User.first.id
)

# Adicione mais contas bancárias conforme necessário
