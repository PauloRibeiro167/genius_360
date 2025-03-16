
puts "\nCriando associações entre Perfis e Permissões..."

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
