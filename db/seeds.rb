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
perfis = %w[Super\ Admin Analista\ de\ Dados Gerente\ Comercial Diretor\ Executivo Operador Marketing Supervisor Monitor\ de\ Fraudes].map { |name| { name: name } }

perfis.each do |perfil|
  Perfil.create!(perfil)
end

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

# Criar associações entre Permissions e ControllerPermissions
puts "\nCriando associações entre Permissions e ControllerPermissions..."

permission_controller_map = {
  "Listar usuários" => { controller: "users", action: "index" },
  "Visualizar usuário" => { controller: "users", action: "show" },
  "Atualizar usuário" => { controller: "users", action: "update" },
  "Remover usuário" => { controller: "users", action: "destroy" },
  
  "Visualizar métricas" => { controller: "metrics", action: "index" },
  "Exportar métricas" => { controller: "metrics", action: "export" },
  "Filtrar métricas" => { controller: "metrics", action: "filter" },
  
  # ...adicione mais mapeamentos conforme necessário
}

permission_controller_map.each do |permission_name, controller_action|
  permission = Permission.find_by(name: permission_name)
  controller_permission = ControllerPermission.find_by(
    controller_name: controller_action[:controller],
    action_name: controller_action[:action]
  )
  
  if permission && controller_permission
    permission.controller_permissions << controller_permission unless permission.controller_permissions.include?(controller_permission)
  end
end

puts "Associações entre Permissions e ControllerPermissions criadas com sucesso!"

# Criar um usuário Super Admin
puts "\nCriando usuário Super Admin..."

admin_user = User.create!(
  email: 'paulorezende877@gmail.com',
  password: 'sua_senha_aqui',
  perfil: Perfil.find_by(name: 'Super Admin')
)

puts "Usuário Super Admin criado com sucesso!"
