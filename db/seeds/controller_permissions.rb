
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
