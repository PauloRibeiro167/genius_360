total_vinculos = 0
vinculos_criados = 0
vinculos_com_erro = 0

if Aviso.count.zero?
    puts "Não há avisos cadastrados."
    puts "Execute primeiro a seed de avisos (#40_avisos.rb)"
    return
end

if User.count.zero?
    puts "Não há usuários cadastrados."
    puts "Execute primeiro a seed de usuários (#10_users.rb)"
    return
end

avisos = Aviso.where(discarded_at: nil)
users = User.all
puts "#{avisos.count} avisos e #{users.count} usuários encontrados"

avisos_globais = avisos.sample(3)

avisos_globais.each do |aviso|
    puts "Processando: #{aviso.titulo}"
    
    users.each do |user|
        begin
            avisos_user = AvisosUser.new(
                aviso_id: aviso.id,
                user_id: user.id
            )
            
            if avisos_user.save
                vinculos_criados += 1
                puts "Vínculo criado para #{user.email}"
            else
                vinculos_com_erro += 1
                puts "Erro ao vincular: #{avisos_user.errors.full_messages.join(', ')}"
            end
        rescue => e
            vinculos_com_erro += 1
            puts "Erro inesperado: #{e.message}"
        end
        total_vinculos += 1
    end
end

perfis = Perfil.all
avisos_por_perfil = avisos.reject { |a| avisos_globais.include?(a) }.sample(5)

avisos_por_perfil.each do |aviso|
    perfis_selecionados = perfis.sample(rand(1..3))
    puts "Processando: #{aviso.titulo} para perfis: #{perfis_selecionados.map(&:name).join(', ')}"
    
    usuarios_dos_perfis = User.where(perfil_id: perfis_selecionados.map(&:id))
    
    usuarios_dos_perfis.each do |user|
        begin
            avisos_user = AvisosUser.new(
                aviso_id: aviso.id,
                user_id: user.id
            )
            
            if avisos_user.save
                vinculos_criados += 1
                puts "Vínculo criado para #{user.email}"
            else
                vinculos_com_erro += 1
                puts "Erro ao vincular: #{avisos_user.errors.full_messages.join(', ')}"
            end
        rescue => e
            vinculos_com_erro += 1
            puts "Erro inesperado: #{e.message}"
        end
        total_vinculos += 1
    end
end

avisos_especificos = avisos.reject { |a| avisos_globais.include?(a) || avisos_por_perfil.include?(a) }

puts "=== Resumo da Operação ==="
puts "Total de vínculos processados: #{total_vinculos}"
puts "Vínculos criados com sucesso: #{vinculos_criados}"
puts "Vínculos com erro: #{vinculos_com_erro}"
puts "Total de avisos no sistema: #{Aviso.count}"
puts "Total de usuários no sistema: #{User.count}"
puts "Operação finalizada em: #{Time.now}"
