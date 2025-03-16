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
