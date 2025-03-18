puts " Iniciando criação de associações entre usuários e perfis..."

total_associacoes = 0
total_erros = 0

usuarios = User.all
perfis = Perfil.all

if usuarios.empty?
  puts " ERRO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

if perfis.empty?
  puts " ERRO: Não existem perfis cadastrados. Execute primeiro a seed de perfis."
  exit
end

puts "Total de usuários encontrados: #{usuarios.count}"
puts "Total de perfis encontrados: #{perfis.count}"

perfis_map = {
  admin: perfis.find { |p| p.name.downcase.strip == 'super admin'.downcase.strip },
  diretor: perfis.find { |p| p.name.downcase.strip == 'diretor executivo'.downcase.strip },
  gerente_marketing: perfis.find { |p| p.name.downcase.strip == 'gerente de marketing'.downcase.strip },
  gerente_estrategia: perfis.find { |p| p.name.downcase.strip == 'gerente de estrategia'.downcase.strip },
  gerente_comercial: perfis.find { |p| p.name.downcase.strip == 'gerente comercial'.downcase.strip },
  gerente_executivo: perfis.find { |p| p.name.downcase.strip == 'gerente executivo'.downcase.strip },
  gestor_crm: perfis.find { |p| p.name.downcase.strip == 'gestor de crm'.downcase.strip },
  gestor_projetos: perfis.find { |p| p.name.downcase.strip == 'gestor de projetos'.downcase.strip },
  analista_dados: perfis.find { |p| p.name.downcase.strip == 'analista de dados'.downcase.strip },
  supervisor: perfis.find { |p| p.name.downcase.strip == 'supervisor'.downcase.strip },
  digitador: perfis.find { |p| p.name.downcase.strip == 'digitador'.downcase.strip },
  monitor_fraudes: perfis.find { |p| p.name.downcase.strip == 'monitor de fraudes'.downcase.strip }
}

puts "Distribuindo perfis aos usuários..."

usuarios.each_with_index do |usuario, index|
  begin
  perfil = case index
    when 0 then perfis_map[:admin]
    when 1 then perfis_map[:diretor]
    when 2 then perfis_map[:gerente_marketing]
    when 3 then perfis_map[:gerente_estrategia]
    when 4 then perfis_map[:gerente_comercial]
    when 5 then perfis_map[:gerente_executivo]
    when 6 then perfis_map[:gestor_crm]
    when 7 then perfis_map[:gestor_projetos]
    when 8 then perfis_map[:analista_dados]
    when 9 then perfis_map[:supervisor]
    when 10 then perfis_map[:digitador]
    when 11 then perfis_map[:monitor_fraudes]
  end
  
  if perfil && PerfilUser.create(user: usuario, perfil: perfil)
    total_associacoes += 1
    puts "Usuário #{usuario.email} associado ao perfil #{perfil.name}"
  end
  rescue => e
  total_erros += 1
  puts "Erro ao associar usuário #{usuario.email}: #{e.message}"
  end
end

if perfis_map[:admin] && PerfilUser.where(perfil: perfis_map[:admin]).count == 0
  begin
    usuario_admin = usuarios.first
    PerfilUser.create!(user: usuario_admin, perfil: perfis_map[:admin])
    total_associacoes += 1
    puts "ATENÇÃO: Usuário #{usuario_admin.email} definido como Super Admin"
  rescue => e
    puts "Erro ao criar Super Admin: #{e.message}"
    total_erros += 1
  end
end

puts "\nEstatísticas de distribuição:"
perfis.each do |perfil|
  count = PerfilUser.where(perfil: perfil).count
  percentual = (count.to_f / usuarios.count * 100).round(1)
  puts "#{perfil.name}: #{count} usuários (#{percentual}%)"
end

puts "\nResumo Final:"
puts "Total de associações criadas: #{total_associacoes}"
puts "Total de erros: #{total_erros}"
puts "Processo finalizado!"
