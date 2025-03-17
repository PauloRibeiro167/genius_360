require 'colorize'

# Função de normalização de strings
def normalizar_string(texto)
    return nil if texto.nil?
    texto.to_s
         .unicode_normalize(:nfkd)
         .encode('ASCII', replace: '')
         .downcase
         .gsub(/[^a-z0-9\s]/i, '')
         .strip
end

puts " Iniciando criação de associações entre usuários e perfis...".colorize(:blue)

# Contadores para estatísticas
total_associacoes = 0
total_erros = 0

# Verifica se existem usuários e perfis no sistema
usuarios = User.all
perfis = Perfil.all

if usuarios.empty?
    puts " ERRO: Não existem usuários cadastrados. Execute primeiro a seed de usuários.".colorize(:red)
    exit
end

if perfis.empty?
    puts " ERRO: Não existem perfis cadastrados. Execute primeiro a seed de perfis.".colorize(:red)
    exit
end

puts "🟣 Total de usuários encontrados: #{usuarios.count}".colorize(:magenta)
puts "🟣 Total de perfis encontrados: #{perfis.count}".colorize(:magenta)

# Mapeamento dos perfis
perfis_map = {
  admin: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Super Admin') },
  diretor: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Diretor Executivo') },
  gerente_marketing: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Gerente de Marketing') },
  gerente_estrategia: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Gerente de Estrategia') },
  gerente_comercial: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Gerente Comercial') },
  gerente_executivo: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Gerente Executivo') },
  gestor_crm: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Gestor de CRM') },
  gestor_projetos: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Gestor de Projetos') },
  analista_dados: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Analista de Dados') },
  supervisor: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Supervisor') },
  digitador: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Digitador') },
  monitor_fraudes: perfis.find { |p| normalizar_string(p.name) == normalizar_string('Monitor de Fraudes') }
}

puts " Distribuindo perfis aos usuários...".colorize(:cyan)

# Atribuição direta de perfis aos usuários
usuarios.each_with_index do |usuario, index|
  begin
    # Seleciona o perfil baseado no índice
    perfil = case index
      when 0 then perfis_map[:admin]              # 1º usuário - Super Admin
      when 1 then perfis_map[:diretor]            # 2º usuário - Diretor Executivo
      when 2 then perfis_map[:gerente_marketing]  # 3º usuário - Gerente de Marketing
      when 3 then perfis_map[:gerente_estrategia] # 4º usuário - Gerente de Estratégia
      when 4 then perfis_map[:gerente_comercial]  # 5º usuário - Gerente Comercial
      when 5 then perfis_map[:gerente_executivo]  # 6º usuário - Gerente Executivo
      when 6 then perfis_map[:gestor_crm]         # 7º usuário - Gestor de CRM
      when 7 then perfis_map[:gestor_projetos]    # 8º usuário - Gestor de Projetos
      when 8 then perfis_map[:analista_dados]     # 9º usuário - Analista de Dados
      when 9 then perfis_map[:supervisor]         # 10º usuário - Supervisor
      when 10 then perfis_map[:digitador]         # 11º usuário - Digitador
      when 11 then perfis_map[:monitor_fraudes]   # 12º usuário - Monitor de Fraudes
    end
    
    if perfil && PerfilUser.create(user: usuario, perfil: perfil)
      total_associacoes += 1
      puts "🟢 Usuário #{usuario.email} associado ao perfil #{perfil.name}".colorize(:green)
    end
  rescue => e
    total_erros += 1
    puts " Erro ao associar usuário #{usuario.email}: #{e.message}".colorize(:red)
  end
end

# Garante que existe pelo menos um Super Admin
if perfis_map[:admin] && PerfilUser.where(perfil: perfis_map[:admin]).count == 0
    begin
        usuario_admin = usuarios.first
        PerfilUser.create!(user: usuario_admin, perfil: perfis_map[:admin])
        total_associacoes += 1
        puts "🟡 ATENÇÃO: Usuário #{usuario_admin.email} definido como Super Admin".colorize(:yellow)
    rescue => e
        puts " Erro ao criar Super Admin: #{e.message}".colorize(:red)
        total_erros += 1
    end
end

# Estatísticas finais
puts "\n⚪ Estatísticas de distribuição:".colorize(:white)
perfis.each do |perfil|
    count = PerfilUser.where(perfil: perfil).count
    percentual = (count.to_f / usuarios.count * 100).round(1)
    puts "⚫ #{perfil.name}: #{count} usuários (#{percentual}%)".colorize(:light_black)
end

puts "\n Resumo Final:".colorize(:blue)
puts "🟢 Total de associações criadas: #{total_associacoes}".colorize(:green)
puts " Total de erros: #{total_erros}".colorize(:red)
puts "🟢 Processo finalizado!".colorize(:green)