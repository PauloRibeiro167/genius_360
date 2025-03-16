puts "Limpeza do banco de dados..."
PerfilPermission.destroy_all
Permission.destroy_all
User.destroy_all
Perfil.destroy_all
puts "Banco de dados limpo."
  
Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |file|
  puts "Carregando seed: #{file}"
  require file
end
