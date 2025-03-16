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