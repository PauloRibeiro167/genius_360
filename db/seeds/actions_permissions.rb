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
