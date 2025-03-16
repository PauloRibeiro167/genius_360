puts "Criando usuários..."

User.create!(
  email: "admin@example.com",
  encrypted_password: Devise::Encryptor.digest(User, 'password'),
  first_name: "Admin",
  last_name: "User",
  cpf: "12345678901",
  phone: "1234567890",
  admin: true
)

# Adicione mais usuários conforme necessário
