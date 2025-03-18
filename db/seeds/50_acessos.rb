begin
  puts "\n=== Iniciando seed de Acessos com Depuração ==="
  # Código extra para depuração
  puts "Testando validação do modelo Acesso:"
  user_teste = User.first
  puts "- User para teste: ID=#{user_teste.id}, Email=#{user_teste.email}"
  
  acesso_teste = Acesso.new(
    user_id: user_teste.id,
    descricao: "Teste de depuração",
    data_acesso: Time.current,
    ip: "127.0.0.1",
    modelo_dispositivo: "Depuração"
  )
  
  if acesso_teste.valid?
    puts "- Acesso de teste é VÁLIDO"
    acesso_teste.save
    puts "- Acesso salvo com ID: #{acesso_teste.id}"
  else
    puts "- Acesso de teste é INVÁLIDO"
    puts "- Erros: #{acesso_teste.errors.full_messages.join(', ')}"
    
    # Verificar apenas o user_id, não a associação user
    puts "- Classe do user_id: #{acesso_teste.user_id.class}"
    puts "- Valor do user_id: #{acesso_teste.user_id.inspect}"
  end

  puts "Data/Hora: #{Time.current}"
  
  total_registros = 0
  erros = []
  inicio = Time.current

  users = User.all.to_a
  
  if users.empty?
    puts "\nAVISO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
    puts "Abortando criação de registros de acesso."
    exit(0)
  end
  
  valid_users = users.select { |u| u.id.present? }
  puts "Encontrados #{valid_users.count} usuários válidos no sistema"
  
  if valid_users.empty?
    puts "AVISO: Nenhum usuário tem ID válido. Verifique o cadastro de usuários."
    puts "Abortando criação de registros de acesso."
    exit(0)
  end

  dispositivos = [
    "iPhone 14 Pro",
    "Samsung Galaxy S23",
    "iPhone 13",
    "Xiaomi Redmi Note 12",
    "Samsung Galaxy A54",
    "Motorola Moto G72",
    "MacBook Pro",
    "Dell XPS 13",
    "iPad Air",
    "Windows Desktop"
  ]

  ips = [
    "187.45.123.45",
    "200.147.89.123",
    "189.75.34.212",
    "177.154.23.78",
    "201.33.65.198",
    "192.168.0.1",
    "10.0.0.15",
    "186.221.45.67",
    "179.124.236.54",
    "45.188.73.124"
  ]

  descricoes = [
    "Login no sistema",
    "Acesso ao módulo de consignados",
    "Consulta de taxas",
    "Geração de relatório",
    "Visualização de propostas",
    "Atualização de cadastro",
    "Login via aplicativo móvel",
    "Tentativa de login inválida",
    "Logout do sistema",
    "Recuperação de senha"
  ]
  
  data_inicial = 30.days.ago
  data_final = Time.current
  quantidade = 150

  puts "\nGerando #{quantidade} registros de acesso..."
  
  ActiveRecord::Base.transaction do
    quantidade.times do |i|
      user = valid_users.sample if valid_users.present? && rand < 0.9
      
      acesso = Acesso.new(
        user_id: user&.id,
        descricao: descricoes.sample,
        data_acesso: rand(data_inicial..data_final),
        ip: ips.sample,
        modelo_dispositivo: dispositivos.sample
      )
      
      if acesso.save
        total_registros += 1
        if (total_registros % 25).zero?
          puts "... #{total_registros} registros criados (#{((i+1.0)/quantidade*100).round(1)}%)"
        end
      else
        erros << "Registro #{i+1}: #{acesso.errors.full_messages.join(', ')}"
      end
    end

    if valid_users.present?
      user_demo = valid_users.first
      puts "\nCriando registros de demonstração para o usuário #{user_demo.email}"
      
      (1..7).each do |dias_atras|
        begin
          Acesso.create!(
            user_id: user_demo.id,
            descricao: "Login diário",
            data_acesso: dias_atras.days.ago.change(hour: 8 + rand(0..1), min: rand(0..59)),
            ip: "187.45.123.45",
            modelo_dispositivo: "MacBook Pro"
          )
          
          Acesso.create!(
            user_id: user_demo.id,
            descricao: "Logout do sistema",
            data_acesso: dias_atras.days.ago.change(hour: 17 + rand(0..1), min: rand(0..59)),
            ip: "187.45.123.45",
            modelo_dispositivo: "MacBook Pro"
          )
          total_registros += 2
        rescue => e
          erros << "Erro nos registros de demonstração - Dia #{dias_atras}: #{e.message}"
        end
      end
    end
  end

  # Adicione isso temporariamente no arquivo de seed para depuração
  acesso = Acesso.new(
    user_id: User.first.id,
    descricao: "Teste",
    data_acesso: Time.current,
    ip: "127.0.0.1",
    modelo_dispositivo: "Teste"
  )

  puts "Acesso é válido? #{acesso.valid?}"
  unless acesso.valid?
    puts "Erros: #{acesso.errors.full_messages.join(', ')}"
  end

  tempo_total = Time.current - inicio
  puts "\n=== Relatório da Seed de Acessos ==="
  puts "Total de registros criados: #{total_registros}"
  puts "Tempo de execução: #{tempo_total.round(2)} segundos"
  puts "Média: #{(total_registros/tempo_total).round(2)} registros/segundo"
  
  if erros.any?
    puts "\nErros encontrados (#{erros.size}):"
    erros.each { |erro| puts "- #{erro}" }
  else
    puts "\nNenhum erro encontrado! ✓"
  end

rescue => e
  puts "\n=== ERRO FATAL NA SEED DE ACESSOS ==="
  puts "Mensagem: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace[0..5]
  raise e
end
