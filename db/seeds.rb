# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Limpeza do banco de dados..."
Perfil.destroy_all
User.destroy_all
Permission.destroy_all
PerfilPermission.destroy_all
puts "Banco de dados limpo."

# Seeds para os Perfis
perfis = [
  {
    name: "Super Admin"
  },
  {
    name: "Analista de Dados"
  },
  {
    name: "Gerente Comercial"
  },
  {
    name: "Diretor Executivo"
  }
]

perfis.each do |perfil|
  Perfil.create!(perfil)
end

# Criar usuário admin
super_admin_perfil = Perfil.find_by(name: "Super Admin") # Encontra o perfil de Super Admin
User.create!(
  email: 'admin@teste.com',
  password: '123456',
  password_confirmation: '123456',
  first_name: 'Admin',
  last_name: 'Test',
  username: 'admintest',
  perfil_id: super_admin_perfil.id
)

# Seeds para as Permissões
permissions = [
  # UsersController
  { name: "Listar usuários" },
  { name: "Visualizar usuário" },
  { name: "Atualizar usuário" },
  { name: "Remover usuário" },

  # MetricsController
  { name: "Visualizar métricas" },
  { name: "Exportar métricas" },
  { name: "Filtrar métricas" },

  # MarketingDemandsController
  { name: "Criar demanda" },
  { name: "Listar demandas" },
  { name: "Visualizar demanda" },
  { name: "Atualizar demanda" },
  { name: "Remover demanda" },

  # SalesController
  { name: "Listar vendas" },
  { name: "Visualizar venda" },
  { name: "Criar venda" },
  { name: "Atualizar venda" },
  { name: "Remover venda" },

  # FinanceController
  { name: "Listar finanças" },
  { name: "Visualizar finança" },
  { name: "Atualizar finança" },
  { name: "Exportar finanças" },

  # SettingsController
  { name: "Visualizar configurações" },
  { name: "Atualizar configurações" }
]

permissions.each do |permission|
  Permission.create!(permission)
end
