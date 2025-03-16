require 'colorize'

begin
  puts "\n Iniciando criação de permissões...".colorize(:blue)

  # Estatísticas de processamento
  stats = { criadas: 0, existentes: 0, erros: 0 }

  # Definição das permissões
  permissions = [
    # UsersController
    { name: "Listar usuários" },
    { name: "Visualizar usuário" },
    { name: "Atualizar usuário" },
    { name: "Remover usuário" },

    # MetricsController
    { name: "Visualizar métricas" },
    { name: "Exportar métricas" },
    { name: "Filtrar métricas" },

    # MarketingDemandsController
    { name: "Criar demanda" },
    { name: "Listar demandas" },
    { name: "Visualizar demanda" },
    { name: "Atualizar demanda" },
    { name: "Remover demanda" },

    # SalesController
    { name: "Listar vendas" },
    { name: "Visualizar venda" },
    { name: "Criar venda" },
    { name: "Atualizar venda" },
    { name: "Remover venda" },

    # FinanceController
    { name: "Listar finanças" },
    { name: "Visualizar finança" },
    { name: "Atualizar finança" },
    { name: "Exportar finanças" },

    # SettingsController
    { name: "Visualizar configurações" },
    { name: "Atualizar configurações" }
  ]

  # Processamento das permissões
  permissions.each do |permission|
    begin
      perm = Permission.find_or_initialize_by(name: permission[:name])
      
      if perm.new_record?
        if perm.save
          puts "🟢 Permissão criada: #{permission[:name]}".colorize(:green)
          stats[:criadas] += 1
        else
          puts " Erro ao criar permissão '#{permission[:name]}': #{perm.errors.full_messages.join(', ')}".colorize(:red)
          stats[:erros] += 1
        end
      else
        puts "⚪ Permissão já existe: #{permission[:name]}".colorize(:white)
        stats[:existentes] += 1
      end
      
    rescue ActiveRecord::RecordInvalid => e
      puts " Erro de validação ao criar permissão '#{permission[:name]}']: #{e.message}".colorize(:red)
      stats[:erros] += 1
    rescue => e
      puts " Erro inesperado ao criar permissão '#{permission[:name]}']: #{e.message}".colorize(:red)
      puts "🟣 Debug: #{e.backtrace[0..2].join("\n")}".colorize(:magenta)
      stats[:erros] += 1
    end
  end

  # Exibição do resumo da operação
  puts "\n Resumo da operação:".colorize(:cyan)
  puts " → Total de permissões processadas: #{permissions.size}".colorize(:blue)
  puts "🟢 → Permissões criadas: #{stats[:criadas]}".colorize(:green)
  puts "⚪ → Permissões existentes: #{stats[:existentes]}".colorize(:white)
  puts " → Erros encontrados: #{stats[:erros]}".colorize(:red)
  puts "⚫ → Total de permissões no sistema: #{Permission.count}".colorize(:light_black)

rescue ActiveRecord::StatementInvalid => e
  puts "\n Erro de banco de dados:".colorize(:red)
  puts " → #{e.message}".colorize(:red)
  puts "\n🟡 Verifique:".colorize(:yellow)
  puts "    1. A tabela 'permissions' existe".colorize(:yellow)
  puts "    2. Todas as migrations foram executadas".colorize(:yellow)
  puts "    3. O banco de dados está acessível".colorize(:yellow)
  
rescue NameError => e
  puts "\n Erro de definição de classe:".colorize(:red)
  puts " → #{e.message}".colorize(:red)
  puts "\n🟡 Verifique:".colorize(:yellow)
  puts "    1. O modelo Permission está definido em #app/models/permission.rb".colorize(:yellow)
  puts "    2. O nome da classe está correto (Permission)".colorize(:yellow)
  puts "    3. O arquivo do modelo está no local correto".colorize(:yellow)
  
rescue => e
  puts "\n Erro inesperado:".colorize(:red)
  puts " → #{e.message}".colorize(:red)
  puts "\n🟣 Stack trace:".colorize(:magenta)
  puts e.backtrace[0..5].map { |line| "    #{line}" }.join("\n").colorize(:magenta)
end