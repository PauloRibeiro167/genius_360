sucessos = 0
erros = 0
start_time = Time.now

puts " Iniciando criação de dados de API..."

def exibir_barra_progresso(atual, total, source)
    porcentagem = (atual.to_f / total * 100).round
    barras_preenchidas = (porcentagem / 5).round
    barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
    print "\r Processando #{source}: [#{barra}] #{porcentagem}% (#{atual}/#{total})"
end

api_sources = [
    "weather_api",
    "stock_market",
    "currency_exchange",
    "customer_data",
    "website_analytics",
    "social_media",
    "sales_metrics",
    "erp_integration",
    "crm_system"
]

puts "\n Gerando dados para diferentes fontes de API..."

begin
    start_date = 90.days.ago
    puts "Data inicial definida como #{start_date.strftime('%d/%m/%Y')}"

    api_sources.each do |source|
        puts "\n Iniciando processamento da fonte: #{source}"
        
        case source
        when "weather_api", "currency_exchange"
            intervals = 90
            interval_hours = 24
        when "stock_market"
            intervals = 90 * 8
            interval_hours = 1
        when "website_analytics", "social_media", "sales_metrics"
            intervals = 90
            interval_hours = 24
        when "customer_data", "erp_integration", "crm_system"
            intervals = 12
            interval_hours = 168
        end

        registros_fonte = 0
        erros_fonte = 0

        (0...intervals).each do |i|
            begin
                collected_at = start_date + (i * interval_hours).hours
                
                data_payload = case source
                when "weather_api"
                    {
                        location: ["Fortaleza", "São Paulo", "Rio de Janeiro", "Brasília", "Recife"].sample,
                        temperature: rand(18..35),
                        humidity: rand(30..95),
                        wind_speed: rand(0..50),
                        condition: ["sunny", "cloudy", "rainy", "partly_cloudy", "stormy"].sample,
                        forecast: [
                            { day: "today", high: rand(25..38), low: rand(16..24), condition: ["sunny", "cloudy", "rainy"].sample },
                            { day: "tomorrow", high: rand(25..38), low: rand(16..24), condition: ["sunny", "cloudy", "rainy"].sample }
                        ]
                    }
                # ... outros casos permanecem iguais
                end
                
                # Criar o registro com data e data_payload
                api_data = ApiData.create!({
                    source: source,
                    data: data_payload,  # Renomeado de 'data' para 'data_payload' para evitar confusão
                    collected_at: collected_at,
                    data: Date.today  # Adicionando o campo data obrigatório
                })
                registros_fonte += 1
                sucessos += 1
                
                exibir_barra_progresso(i + 1, intervals, source)
            rescue => e
                erros += 1
                erros_fonte += 1
                puts "\n Erro ao processar #{source}: #{e.message}"
            end
        end

        print "\r" + (" " * 100) + "\r"
        
        puts "#{source} concluído: #{registros_fonte} registros criados"
        puts "#{erros_fonte} erros encontrados" if erros_fonte > 0
        puts "Tempo decorrido: #{(Time.now - start_time).round} segundos"
    end

    puts "\nAdicionando dados recentes (últimas 24h) para testes de dashboards..."

    24.times do |hour|
        collected_at = Time.now - hour.hours
        
        ["stock_market", "website_analytics", "sales_metrics"].each do |source|
            data = case source
            when "stock_market"
                stocks = ["PETR4", "VALE3", "ITUB4", "BBDC4", "ABEV3"]
                stock_data = {}
                stocks.each do |stock|
                    base_price = rand(10.0..100.0).round(2)
                    variation = rand(-0.5..0.5)
                    stock_data[stock] = {
                        open: base_price,
                        close: (base_price + variation).round(2),
                        high: (base_price + rand(0.1..1.0)).round(2),
                        low: (base_price - rand(0.1..1.0)).round(2),
                        volume: rand(10000..1000000)
                    }
                end
                { market_status: hour >= 8 && hour <= 17 ? "open" : "closed", stocks: stock_data }
            when "website_analytics"
                {
                    active_users: rand(50..500),
                    page_views_last_hour: rand(100..2000),
                    top_pages: [
                        { url: "/", views: rand(50..200) },
                        { url: "/produtos", views: rand(30..150) },
                        { url: "/contato", views: rand(10..50) }
                    ],
                    user_locations: {
                        "Brasil": rand(70..90),
                        "Estados Unidos": rand(2..10),
                        "Portugal": rand(1..5),
                        "Outros": rand(1..10)
                    }
                }
            when "sales_metrics"
                {
                    revenue_last_hour: rand(1000..10000),
                    transactions_last_hour: rand(5..50),
                    conversion_rate: rand(1.0..10.0).round(2),
                    cart_abandonment: rand(40..80)
                }
            end
            
            api_data = ApiData.new(
                source: source,
                data: data,
                collected_at: collected_at
            )
            
            api_data.save
        end
    end

    puts "\n=== Resumo da Operação ==="
    puts "Total de registros criados: #{sucessos}"
    puts "Total de erros: #{erros}" if erros > 0
    puts "Tempo total de execução: #{(Time.now - start_time).round} segundos"

    puts "\nÚltimo registro em #{ApiData.maximum(:created_at)&.strftime('%d/%m/%Y %H:%M:%S')}"
    
    fontes_sem_dados = api_sources.select { |source| ApiData.where(source: source).count.zero? }
    if fontes_sem_dados.any?
        puts "\nFontes sem dados:"
        fontes_sem_dados.each do |source|
            puts "  - #{source}"
        end
    end

    puts "\nProcesso de criação de dados de API concluído!"
rescue => e
    puts "\nErro fatal durante a execução: #{e.message}"
    puts "#{e.backtrace.first}"
end
