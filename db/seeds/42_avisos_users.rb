require 'colorize'

# Função para normalizar texto
def normalizar_texto(texto)
    return nil if texto.nil?
    texto.to_s
         .unicode_normalize(:nfkd)
         .gsub(/[^\x00-\x7F]/, '')
         .gsub(/[^\w\s-]/, ' ')
         .squeeze(' ')
         .strip
end

# Contadores para estatísticas
total_vinculos = 0
vinculos_criados = 0
vinculos_com_erro = 0

puts "\n Iniciando vinculação de avisos aos usuários...".colorize(:blue)

# Verifica se existem avisos e usuários no sistema
if Aviso.count.zero?
    puts "🟡 Aviso: Não há avisos cadastrados.".colorize(:yellow)
    puts "⚪ Execute primeiro a seed de avisos (#40_avisos.rb)".colorize(:white)
    return
end

if User.count.zero?
    puts "🟡 Aviso: Não há usuários cadastrados.".colorize(:yellow)
    puts "⚪ Execute primeiro a seed de usuários (#10_users.rb)".colorize(:white)
    return
end

# Obter todos os avisos e usuários
puts " Carregando avisos e usuários...".colorize(:cyan)
avisos = Aviso.where(discarded_at: nil)
users = User.all
puts "🟣 Debug: #{avisos.count} avisos e #{users.count} usuários encontrados".colorize(:magenta)

puts "\n Distribuindo avisos entre os usuários:".colorize(:blue)

# 1. Avisos globais
avisos_globais = avisos.sample(3)
puts "\n⚪ 1. Avisos globais (para todos os usuários):".colorize(:white)

avisos_globais.each do |aviso|
    puts " Processando: #{normalizar_texto(aviso.titulo)}".colorize(:cyan)
    
    users.each do |user|
        begin
            avisos_user = AvisosUser.new(
                aviso_id: aviso.id,
                user_id: user.id
            )
            
            if avisos_user.save
                vinculos_criados += 1
                puts "🟢 Vínculo criado para #{user.email}".colorize(:green)
            else
                vinculos_com_erro += 1
                puts " Erro ao vincular: #{avisos_user.errors.full_messages.join(', ')}".colorize(:red)
            end
        rescue => e
            vinculos_com_erro += 1
            puts " Erro inesperado: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
        end
        total_vinculos += 1
    end
end

# 2. Avisos específicos por perfil
perfis = Perfil.all
avisos_por_perfil = avisos.reject { |a| avisos_globais.include?(a) }.sample(5)
puts "\n⚪ 2. Avisos específicos por perfil:".colorize(:white)

avisos_por_perfil.each do |aviso|
    # Seleciona 1-3 perfis aleatoriamente para receber este aviso
    perfis_selecionados = perfis.sample(rand(1..3))
    
    puts " Processando: #{normalizar_texto(aviso.titulo)} para perfis: #{perfis_selecionados.map(&:name).join(', ')}".colorize(:cyan)
    
    # Obtém todos os usuários desses perfis
    usuarios_dos_perfis = User.where(perfil_id: perfis_selecionados.map(&:id))
    
    usuarios_dos_perfis.each do |user|
        begin
            avisos_user = AvisosUser.new(
                aviso_id: aviso.id,
                user_id: user.id
            )
            
            if avisos_user.save
                vinculos_criados += 1
                puts "🟢 Vínculo criado para #{user.email}".colorize(:green)
            else
                vinculos_com_erro += 1
                puts " Erro ao vincular: #{avisos_user.errors.full_messages.join(', ')}".colorize(:red)
            end
        rescue => e
            vinculos_com_erro += 1
            puts " Erro inesperado: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
        end
        total_vinculos += 1
    end
end

# 3. Avisos para usuários específicos aleatoriamente
avisos_especificos = avisos.reject { |a| avisos_globais.include?(a) || avisos_por_perfil.include?(a) }

# Resumo final
puts "\n=== Resumo da Operação ===".colorize(:white)
puts "⚪ Total de vínculos processados: #{total_vinculos}".colorize(:white)
puts "🟢 Vínculos criados com sucesso: #{vinculos_criados}".colorize(:green)
puts " Vínculos com erro: #{vinculos_com_erro}".colorize(:red)
puts " Total de avisos no sistema: #{Aviso.count}".colorize(:cyan)
puts " Total de usuários no sistema: #{User.count}".colorize(:cyan)
puts "⚫ Operação finalizada em: #{Time.now}".colorize(:light_black)