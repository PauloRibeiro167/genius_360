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
PerfilPermission.destroy_all
Permission.destroy_all
User.destroy_all
Perfil.destroy_all
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
  },
  {
    name: "Operador"
  },
  {
    name: "Marketing"
  },
  {
    name: "Supervisor"
  },
  {
    name: "Monitor de Fraudes"
  }
]

perfis.each do |perfil|
  Perfil.create!(perfil)
end

# Criar usuário admin
super_admin_perfil = Perfil.find_by(name: "Super Admin")
User.create!(
  email: 'admin@teste.com',
  password: '123456',
  password_confirmation: '123456',
  first_name: 'Admin',
  last_name: 'Test',
  perfil_id: super_admin_perfil.id 
)

# Definir senha padrão para todos os usuários
SENHA_PADRAO = 'Genius@2024'

# Usuários padrões do sistema - todos como Super Admin
# Brena Matos
User.create!(
  email: 'brenamatos@geniusdi.com',
  password: SENHA_PADRAO,
  password_confirmation: SENHA_PADRAO,
  first_name: 'Brena',
  last_name: 'Matos',
  perfil_id: super_admin_perfil.id
)

# Paulo Ribeiro
User.create!(
  email: 'paulorezende@geniusdi.com',
  password: 'Paulo1lotusred',
  password_confirmation: 'Paulo1lotusred',
  first_name: 'Paulo',
  last_name: 'Ribeiro',
  perfil_id: super_admin_perfil.id
)

# Junior Peixoto
User.create!(
  email: 'juniorpeixoto@geniusdi.com',
  password: SENHA_PADRAO,
  password_confirmation: SENHA_PADRAO,
  first_name: 'Junior',
  last_name: 'Peixoto',
  perfil_id: super_admin_perfil.id
)

# Lucas Moreira
User.create!(
  email: 'lucasmoreira@geniusdi.com',
  password: SENHA_PADRAO,
  password_confirmation: SENHA_PADRAO,
  first_name: 'Lucas',
  last_name: 'Moreira',
  perfil_id: super_admin_perfil.id
)

puts "Usuários criados com sucesso!"
puts "Senha padrão para todos os usuários (exceto Paulo): #{SENHA_PADRAO}"

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

# Seeds para as Actions Permissions
action_permissions = [
  # Ações do Controller
  { name: "index" },
  { name: "show" },
  { name: "create" },
  { name: "update" },
  { name: "destroy" },
  
  # Ações específicas
  { name: "export" },
  { name: "filter" },
  { name: "import" },
  { name: "approve" },
  { name: "reject" },
  { name: "cancel" },
  { name: "restore" }
]

puts "\nCriando Action Permissions..."
action_permissions.each do |action|
  ActionPermission.create!(action)
end
puts "Action Permissions criadas com sucesso!"

puts "\nCriando Controller Permissions..."

controller_permissions = [
  # UsersController
  { controller_name: "users", action_name: "index", description: "Listagem de usuários" },
  { controller_name: "users", action_name: "show", description: "Visualização de usuário" },
  { controller_name: "users", action_name: "create", description: "Criação de usuário" },
  { controller_name: "users", action_name: "update", description: "Atualização de usuário" },
  { controller_name: "users", action_name: "destroy", description: "Remoção de usuário" },

  # MetricsController
  { controller_name: "metrics", action_name: "index", description: "Visualização de métricas" },
  { controller_name: "metrics", action_name: "export", description: "Exportação de métricas" },
  { controller_name: "metrics", action_name: "filter", description: "Filtragem de métricas" },

  # MarketingDemandsController
  { controller_name: "marketing_demands", action_name: "index", description: "Listagem de demandas" },
  { controller_name: "marketing_demands", action_name: "show", description: "Visualização de demanda" },
  { controller_name: "marketing_demands", action_name: "create", description: "Criação de demanda" },
  { controller_name: "marketing_demands", action_name: "update", description: "Atualização de demanda" },
  { controller_name: "marketing_demands", action_name: "destroy", description: "Remoção de demanda" },

  # SalesController
  { controller_name: "sales", action_name: "index", description: "Listagem de vendas" },
  { controller_name: "sales", action_name: "show", description: "Visualização de venda" },
  { controller_name: "sales", action_name: "create", description: "Criação de venda" },
  { controller_name: "sales", action_name: "update", description: "Atualização de venda" },
  { controller_name: "sales", action_name: "destroy", description: "Remoção de venda" },

  # FinanceController
  { controller_name: "finance", action_name: "index", description: "Listagem de finanças" },
  { controller_name: "finance", action_name: "show", description: "Visualização de finança" },
  { controller_name: "finance", action_name: "update", description: "Atualização de finança" },
  { controller_name: "finance", action_name: "export", description: "Exportação de finanças" },

  # SettingsController
  { controller_name: "settings", action_name: "show", description: "Visualização de configurações" },
  { controller_name: "settings", action_name: "update", description: "Atualização de configurações" }
]

controller_permissions.each do |permission|
  ControllerPermission.create!(permission)
end

puts "Controller Permissions criadas com sucesso!"

# Após a criação das permissions, adicione:

puts "\nCriando associações entre Perfis e Permissões..."

# Hash com as permissões para cada perfil
perfil_permissions_map = {
  "Super Admin" => Permission.all.pluck(:name), # Todas as permissões

  "Analista de Dados" => [
    "Visualizar métricas",
    "Exportar métricas",
    "Filtrar métricas",
    "Listar vendas",
    "Visualizar venda",
    "Listar finanças",
    "Visualizar finança"
  ],

  "Gerente Comercial" => [
    "Listar vendas",
    "Visualizar venda",
    "Criar venda",
    "Atualizar venda",
    "Visualizar métricas",
    "Exportar métricas",
    "Filtrar métricas"
  ],

  "Diretor Executivo" => [
    "Visualizar métricas",
    "Exportar métricas",
    "Filtrar métricas",
    "Listar vendas",
    "Visualizar venda",
    "Listar finanças",
    "Visualizar finança",
    "Exportar finanças",
    "Visualizar configurações"
  ],

  "Operador" => [
    "Listar vendas",
    "Visualizar venda",
    "Criar venda"
  ],

  "Marketing" => [
    "Criar demanda",
    "Listar demandas",
    "Visualizar demanda",
    "Atualizar demanda",
    "Visualizar métricas",
    "Filtrar métricas"
  ],

  "Supervisor" => [
    "Listar usuários",
    "Visualizar usuário",
    "Listar vendas",
    "Visualizar venda",
    "Atualizar venda",
    "Visualizar métricas",
    "Filtrar métricas"
  ],

  "Monitor de Fraudes" => [
    "Listar vendas",
    "Visualizar venda",
    "Listar finanças",
    "Visualizar finança",
    "Visualizar métricas",
    "Filtrar métricas"
  ]
}

# Criar as associações
perfil_permissions_map.each do |perfil_name, permission_names|
  perfil = Perfil.find_by(name: perfil_name)
  
  permission_names.each do |permission_name|
    permission = Permission.find_by(name: permission_name)
    if perfil && permission
      PerfilPermission.create!(
        perfil: perfil,
        permission: permission
      )
    end
  end
end

puts "Associações entre Perfis e Permissões criadas com sucesso!"
