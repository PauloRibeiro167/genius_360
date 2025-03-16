puts "\nCriando relações entre avisos e usuários..."

# Verifica se existem avisos e usuários no sistema
if Aviso.count.zero?
  puts "Não há avisos cadastrados. Execute primeiro a seed de avisos."
  return
end

if User.count.zero?
  puts "Não há usuários cadastrados. Execute primeiro a seed de usuários."
  return
end

# Obter todos os avisos e usuários
avisos = Aviso.where(discarded_at: nil)
users = User.all

puts "\nDistribuindo avisos entre os usuários:"

# Diferentes estratégias de distribuição dos avisos
# 1. Avisos para todos os usuários (avisos globais)
avisos_globais = avisos.sample(3)
puts "1. Avisos globais (para todos os usuários):"

avisos_globais.each do |aviso|
  puts "   - '#{aviso.titulo}'"
  
  users.each do |user|
    avisos_user = AvisosUser.new(
      aviso_id: aviso.id,
      user_id: user.id
    )
    
    unless avisos_user.save
      puts "   Erro ao vincular aviso '#{aviso.titulo}' ao usuário #{user.email}: #{avisos_user.errors.full_messages.join(', ')}"
    end
  end
end

# 2. Avisos específicos por perfil
perfis = Perfil.all
avisos_por_perfil = avisos.reject { |a| avisos_globais.include?(a) }.sample(5)
puts "\n2. Avisos específicos por perfil:"

avisos_por_perfil.each do |aviso|
  # Seleciona 1-3 perfis aleatoriamente para receber este aviso
  perfis_selecionados = perfis.sample(rand(1..3))
  
  puts "   - '#{aviso.titulo}' para perfis: #{perfis_selecionados.map(&:name).join(', ')}"
  
  # Obtém todos os usuários desses perfis
  usuarios_dos_perfis = User.where(perfil_id: perfis_selecionados.map(&:id))
  
  usuarios_dos_perfis.each do |user|
    avisos_user = AvisosUser.new(
      aviso_id: aviso.id,
      user_id: user.id
    )
    
    unless avisos_user.save
      puts "   Erro ao vincular aviso '#{aviso.titulo}' ao usuário #{user.email}: #{avisos_user.errors.full_messages.join(', ')}"
    end
  end
end

# 3. Avisos para usuários específicos aleatoriamente
avisos_especificos = avisos.reject { |a| avisos_globais.include?(a) || avisos_por_perfil.include?(a) }