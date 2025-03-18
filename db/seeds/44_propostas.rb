def exibir_barra_progresso(atual, total, tipo)
    porcentagem = (atual.to_f / total * 100).round
    barras_preenchidas = (porcentagem / 5).round
    barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
    print "\r Processando #{tipo}: [#{barra}] #{porcentagem}% (#{atual}/#{total})"
end

puts "\n Iniciando geração de propostas fictícias..."

status_propostas = [
  'pre_digitacao',
  'rascunho',
  'em_digitacao',
  'aguardando_documentos',
  'em_analise',
  'em_analise_credito',
  'pendente_conformidade',
  'aprovada',
  'rejeitada',
  'cancelada',
  'em_formalizacao',
  'formalizada'
]

prefixos_propostas = [
  "COM-",
  "CORP-",
  "INST-",
  "VIP-",
  "GOV-",
  "PRJ-"
]

def gerar_numero_proposta(prefixo)
  data = Time.current
  ano = data.year
  mes = data.month
  sequencia = rand(1..999999)
  
  format("%04d.%02d.%06d", ano, mes, sequencia)
end

total_propostas = 50
propostas_criadas = 0
erros = 0
start_time = Time.now

begin
    puts "\n Gerando #{total_propostas} propostas com status variados..."
    
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
                puts "\n Erro ao criar proposta #{numero}: #{proposta.errors.full_messages.join(', ')}"
            end
        rescue => e
            erros += 1
            puts "\n Erro inesperado: #{e.message}"
            puts "Debug: #{e.backtrace.first}"
        end
    end

    puts "\n#{propostas_criadas} propostas base criadas com sucesso!"
    
    puts "\n Criando propostas específicas para testes..."
    
    propostas_teste = {
        'em_analise' => 3,
        'aprovada' => 5,
        'rascunho' => 2
    }
    
    propostas_teste.each do |status, quantidade|
        quantidade.times do |i|
            begin
                prefixo = prefixos_propostas.sample
                numero = gerar_numero_proposta(prefixo)
                
                proposta = Proposta.create(numero: numero, status: status)
                
                if proposta.persisted?
                    puts "Proposta #{status.downcase} criada: #{numero}"
                else
                    puts "Falha ao criar proposta #{status.downcase}: #{numero}"
                    erros += 1
                end
            rescue => e
                erros += 1
                puts "Erro ao criar proposta #{status}: #{e.message}"
            end
        end
    end
    
    puts "\n=== Estatísticas de Propostas ==="
    total_por_status = {}
    
    status_propostas.each do |status|
        contagem = Proposta.where(status: status).count
        total_por_status[status] = contagem
        puts "#{status}: #{contagem} propostas"
    end
    
    puts "\n=== Resumo da Operação ==="
    puts "Total de propostas criadas: #{Proposta.count}"
    puts "Total de erros: #{erros}" if erros > 0
    puts "Tempo de execução: #{(Time.now - start_time).round} segundos"
    
    if Proposta.count == 0
        puts "\nATENÇÃO: Nenhuma proposta foi criada!"
        puts "Verifique se a tabela 'propostas' existe no banco de dados."
    end

rescue => e
    puts "\nErro fatal durante a execução: #{e.message}"
    puts "Debug: #{e.backtrace.first}"
end
