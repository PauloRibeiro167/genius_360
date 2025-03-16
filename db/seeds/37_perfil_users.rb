puts "Criando associações entre usuários e perfis..."

# Limpa registros existentes para evitar duplicações
# PerfilUser.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários e perfis no sistema
usuarios = User.all
perfis = Perfil.all

if usuarios.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

if perfis.empty?
  puts "ATENÇÃO: Não existem perfis cadastrados. Execute primeiro a seed de perfis."
  exit
end

# Contador de associações criadas
associacoes_criadas = 0

# Distribuição de perfis
# Admin: 5% dos usuários
# Gerente: 15% dos usuários
# Supervisor: 30% dos usuários
# Operador: 50% dos usuários
puts "Atribuindo perfis aos usuários..."

# Perfis disponíveis (assumindo que existam esses nomes de perfis)
perfil_admin = perfis.find_by(nome: 'Administrador')
perfil_gerente = perfis.find_by(nome: 'Gerente')
perfil_supervisor = perfis.find_by(nome: 'Supervisor')
perfil_operador = perfis.find_by(nome: 'Operador')

usuarios.each do |usuario|
  # Define o perfil com base em uma distribuição percentual
  perfil = case rand(100)
           when 0..4   # 5% administradores
             perfil_admin
           when 5..19  # 15% gerentes
             perfil_gerente
           when 20..49 # 30% supervisores
             perfil_supervisor
           else        # 50% operadores
             perfil_operador
           end
  
  # Cria a associação
  if perfil && PerfilUser.create(user: usuario, perfil: perfil)
    associacoes_criadas += 1
    puts "Usuário #{usuario.email} associado ao perfil #{perfil.nome}"
  end
end

# Garante que pelo menos um usuário tenha perfil de administrador
if perfil_admin && PerfilUser.where(perfil: perfil_admin).count == 0
  usuario_admin = usuarios.first
  PerfilUser.create!(user: usuario_admin, perfil: perfil_admin)
  associacoes_criadas += 1
  puts "ADMIN GARANTIDO: Usuário #{usuario_admin.email} definido como administrador"
end

# Estatísticas das associações
puts "\nEstatísticas de distribuição de perfis:"
perfis.each do |perfil|
  count = PerfilUser.where(perfil: perfil).count
  percentual = (count.to_f / usuarios.count * 100).round(1)
  puts "- #{perfil.nome}: #{count} usuários (#{percentual}%)"
end

puts "\nTotal de associações criadas: #{associacoes_criadas}"
puts "Associações entre usuários e perfis criadas com sucesso!"