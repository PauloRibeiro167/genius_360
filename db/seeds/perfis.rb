# Seeds para os Perfis
puts "Criando perfis..."

perfis = %w[
  Super Admin
  Analista de Dados
  Gerente Comercial
  Gerente Executivo
  Diretor Executivo
  Digitador
  Gerente de Marketing
  Gerente de Estrategia
  Supervisor
  Monitor de Fraudes
  Gestor de CRM
].freeze

# Criar os perfis no banco de dados
perfis.each do |nome|
  Perfil.find_or_create_by!(name: nome)
  puts "- Perfil '#{nome}' criado/verificado"
end

puts "Criação de perfis concluída!"
