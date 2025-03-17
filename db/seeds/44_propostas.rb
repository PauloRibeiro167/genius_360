require 'colorize'

def exibir_barra_progresso(atual, total, tipo)
    porcentagem = (atual.to_f / total * 100).round
    barras_preenchidas = (porcentagem / 5).round
    barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
    print "\r Processando #{tipo}: [#{barra}] #{porcentagem}% (#{atual}/#{total})".colorize(:cyan)
end

puts "\n Iniciando geração de propostas fictícias...".colorize(:blue)

# Status possíveis para as propostas
status_propostas = [
  "Em análise",
  "Aprovada",
  "Reprovada",
  "Aguardando documentação",
  "Em negociação",
  "Finalizada",
  "Cancelada",
  "Pendente",
  "Em revisão"
]

# Prefixos para diferentes tipos de propostas
prefixos_propostas = [
  "COM-", # Comercial
  "CORP-", # Corporativo
  "INST-", # Institucional
  "VIP-", # Cliente VIP
  "GOV-", # Governamental
  "PRJ-"  # Projeto especial
]

# Função para gerar um número de proposta único
def gerar_numero_proposta(prefixo)
  ano = Time.now.year
  sequencia = rand(1000..9999)
  "#{prefixo}#{ano}-#{sequencia}"
end

# Contadores para estatísticas
total_propostas = 50
propostas_criadas = 0
erros = 0
start_time = Time.now

begin
    puts "\n Gerando #{total_propostas} propostas com status variados...".colorize(:cyan)
    
    total_propostas.times do |i|
        begin
            prefixo = prefixos_propostas.sample
            numero = gerar_numero_proposta(prefixo)
            status = status_propostas.sample
            
            proposta = Proposta.new(numero: numero, status: status)
            
            if proposta.save
                propostas_criadas += 1
                exibir_barra_progresso(i + 1, total_propostas, "propostas base")
            else
                erros += 1
                puts "\n Erro ao criar proposta #{numero}: #{proposta.errors.full_messages.join(', ')}".colorize(:red)
            end
        rescue => e
            erros += 1
            puts "\n Erro inesperado: #{e.message}".colorize(:red)
            puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
        end
    end

    puts "\n🟢 #{propostas_criadas} propostas base criadas com sucesso!".colorize(:green)
    
    # Criação de propostas específicas para teste
    puts "\n Criando propostas específicas para testes...".colorize(:blue)
    
    propostas_teste = {
        "Em análise" => 3,
        "Aprovada" => 5,
        "Pendente" => 2
    }
    
    propostas_teste.each do |status, quantidade|
        quantidade.times do |i|
            begin
                prefixo = prefixos_propostas.sample
                numero = gerar_numero_proposta(prefixo)
                
                proposta = Proposta.create(numero: numero, status: status)
                
                if proposta.persisted?
                    puts "🟢 Proposta #{status.downcase} criada: #{numero}".colorize(:green)
                else
                    puts " Falha ao criar proposta #{status.downcase}: #{numero}".colorize(:red)
                    erros += 1
                end
            rescue => e
                erros += 1
                puts " Erro ao criar proposta #{status}: #{e.message}".colorize(:red)
            end
        end
    end
    
    # Estatísticas finais
    puts "\n === Estatísticas de Propostas ===".colorize(:blue)
    total_por_status = {}
    
    status_propostas.each do |status|
        contagem = Proposta.where(status: status).count
        total_por_status[status] = contagem
        cor = contagem > 0 ? :green : :yellow
        puts "⚪ #{status}: #{contagem} propostas".colorize(cor)
    end
    
    puts "\n=== Resumo da Operação ===".colorize(:blue)
    puts "🟢 Total de propostas criadas: #{Proposta.count}".colorize(:green)
    puts " Total de erros: #{erros}".colorize(:red) if erros > 0
    puts "⚫ Tempo de execução: #{(Time.now - start_time).round} segundos".colorize(:light_black)
    
    if Proposta.count == 0
        puts "\n🟡 ATENÇÃO: Nenhuma proposta foi criada!".colorize(:yellow)
        puts "🟡 Verifique se a tabela 'propostas' existe no banco de dados.".colorize(:yellow)
    end

rescue => e
    puts "\n Erro fatal durante a execução: #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
end