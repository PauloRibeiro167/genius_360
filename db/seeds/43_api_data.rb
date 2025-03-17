require 'colorize'

# Contadores para estatísticas
sucessos = 0
erros = 0
start_time = Time.now  # Adicionando inicialização do tempo de início

puts " Iniciando criação de dados de API...".colorize(:blue)

# Função de normalização dos dados
def normalizar_dados(api_data)
    {
        source: api_data[:source].to_s.strip,
        data: api_data[:data],
        collected_at: api_data[:collected_at]
    }
end

def exibir_barra_progresso(atual, total, source)
    porcentagem = (atual.to_f / total * 100).round
    barras_preenchidas = (porcentagem / 5).round
    barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
    print "\r Processando #{source}: [#{barra}] #{porcentagem}% (#{atual}/#{total})".colorize(:cyan)
end

# Fontes de API simuladas
api_sources = [
    "weather_api",        # API de clima
    "stock_market",       # API de mercado de ações
    "currency_exchange",  # API de câmbio de moedas
    "customer_data",      # API de dados de clientes
    "website_analytics",  # API de analytics de website
    "social_media",       # API de mídias sociais
    "sales_metrics",      # API de métricas de vendas
    "erp_integration",    # Integração com ERP
    "crm_system"         # Sistema de CRM
]

puts "\n Gerando dados para diferentes fontes de API...".colorize(:blue)

begin
    # Data mais antiga para começar a série temporal
    start_date = 90.days.ago
    puts "🟣 Debug: Data inicial definida como #{start_date.strftime('%d/%m/%Y')}".colorize(:magenta)

    api_sources.each do |source|
        puts "\n Iniciando processamento da fonte: #{source}".colorize(:blue)
        
        # Define intervalos baseados no tipo de fonte
        case source
        when "weather_api", "currency_exchange"
            intervals = 90  # 90 dias de dados
            interval_hours = 24
        when "stock_market"
            intervals = 90 * 8  # 90 dias x 8 horas de mercado
            interval_hours = 1
        when "website_analytics", "social_media", "sales_metrics"
            intervals = 90  # 90 dias
            interval_hours = 24
        when "customer_data", "erp_integration", "crm_system"
            intervals = 12  # ~12 semanas
            interval_hours = 168  # 7 dias
        end

        registros_fonte = 0
        erros_fonte = 0

        # Processamento dos registros
        (0...intervals).each do |i|
            begin
                collected_at = start_date + (i * interval_hours).hours
                
                # Gera dados específicos para cada fonte
                data = case source
                when "weather_api"
                    # Dados meteorológicos
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
                when "stock_market"
                    # Dados de mercado de ações
                    stocks = ["PETR4", "VALE3", "ITUB4", "BBDC4", "ABEV3"]
                    stock_data = {}
                    stocks.each do |stock|
                        stock_data[stock] = {
                            open: rand(10.0..100.0).round(2),
                            close: rand(10.0..100.0).round(2),
                            high: rand(10.0..100.0).round(2),
                            low: rand(10.0..100.0).round(2),
                            volume: rand(100000..10000000)
                        }
                    end
                    { market_status: ["open", "closed"].sample, stocks: stock_data }
                when "currency_exchange"
                    # Dados de câmbio
                    {
                        base_currency: "BRL",
                        rates: {
                            USD: rand(4.8..5.2).round(4),
                            EUR: rand(5.2..5.7).round(4),
                            GBP: rand(6.0..6.5).round(4),
                            JPY: rand(0.035..0.042).round(6),
                            ARS: rand(0.01..0.02).round(6)
                        },
                        timestamp: collected_at.to_i
                    }
                when "customer_data"
                    # Dados de clientes
                    {
                        total_customers: rand(5000..10000),
                        new_customers: rand(50..200),
                        churn_rate: rand(0.01..0.05).round(4),
                        active_customers: rand(3000..8000),
                        demographics: {
                            age_groups: {
                                "18-24": rand(10..20),
                                "25-34": rand(20..35),
                                "35-44": rand(20..30),
                                "45-54": rand(15..25),
                                "55+": rand(10..20)
                            },
                            gender: {
                                male: rand(40..60),
                                female: rand(40..60),
                                other: rand(1..5)
                            },
                            locations: ["Nordeste", "Sudeste", "Sul", "Norte", "Centro-Oeste"]
                        }
                    }
                when "website_analytics"
                    # Dados de analytics de website
                    {
                        visitors: rand(1000..5000),
                        page_views: rand(3000..15000),
                        bounce_rate: rand(20..60),
                        avg_session_duration: rand(30..300),
                        traffic_sources: {
                            direct: rand(20..40),
                            organic: rand(20..40),
                            referral: rand(5..20),
                            social: rand(10..30),
                            email: rand(5..15)
                        },
                        top_pages: [
                            { url: "/", views: rand(500..2000) },
                            { url: "/produtos", views: rand(300..1500) },
                            { url: "/contato", views: rand(100..500) },
                            { url: "/sobre", views: rand(50..300) },
                            { url: "/blog", views: rand(200..800) }
                        ]
                    }
                when "social_media"
                    # Dados de mídias sociais
                    {
                        platforms: {
                            facebook: {
                                followers: rand(5000..50000),
                                engagement: rand(1..10),
                                posts: rand(5..20),
                                reach: rand(10000..100000)
                            },
                            instagram: {
                                followers: rand(10000..100000),
                                engagement: rand(2..15),
                                posts: rand(5..30),
                                reach: rand(20000..200000)
                            },
                            twitter: {
                                followers: rand(3000..30000),
                                engagement: rand(1..8),
                                posts: rand(10..50),
                                reach: rand(5000..50000)
                            },
                            linkedin: {
                                followers: rand(2000..20000),
                                engagement: rand(1..5),
                                posts: rand(3..15),
                                reach: rand(3000..30000)
                            }
                        },
                        sentiment_analysis: {
                            positive: rand(40..80),
                            neutral: rand(10..40),
                            negative: rand(5..20)
                        }
                    }
                when "sales_metrics"
                    # Dados de métricas de vendas
                    {
                        total_revenue: rand(50000..500000),
                        transactions: rand(100..1000),
                        average_ticket: rand(100..5000),
                        top_products: [
                            { name: "Produto A", sales: rand(10..100), revenue: rand(1000..10000) },
                            { name: "Produto B", sales: rand(10..100), revenue: rand(1000..10000) },
                            { name: "Produto C", sales: rand(10..100), revenue: rand(1000..10000) },
                            { name: "Produto D", sales: rand(10..100), revenue: rand(1000..10000) },
                            { name: "Produto E", sales: rand(10..100), revenue: rand(1000..10000) }
                        ],
                        sales_channels: {
                            online: rand(40..70),
                            physical_stores: rand(20..50),
                            phone: rand(5..15),
                            partners: rand(5..20)
                        }
                    }
                when "erp_integration"
                    # Dados de integração com ERP
                    {
                        inventory_status: {
                            total_items: rand(1000..10000),
                            low_stock_items: rand(10..200),
                            out_of_stock: rand(5..50),
                            incoming_shipments: rand(5..30)
                        },
                        orders: {
                            pending: rand(10..100),
                            processing: rand(20..200),
                            shipped: rand(30..300),
                            delivered: rand(50..500),
                            returned: rand(5..50)
                        },
                        financial: {
                            accounts_receivable: rand(50000..500000),
                            accounts_payable: rand(30000..300000),
                            cash_flow: rand(-50000..100000)
                        }
                    }
                when "crm_system"
                    # Dados de CRM
                    {
                        leads: {
                            new: rand(20..200),
                            qualified: rand(10..100),
                            converted: rand(5..50),
                            lost: rand(10..100)
                        },
                        opportunities: {
                            total: rand(50..500),
                            open: rand(20..200),
                            won: rand(10..100),
                            lost: rand(10..100),
                            value: rand(100000..1000000)
                        },
                        customer_satisfaction: {
                            nps: rand(0..100),
                            csat: rand(1..5)
                        },
                        support_tickets: {
                            open: rand(10..100),
                            in_progress: rand(5..50),
                            resolved: rand(20..200),
                            avg_resolution_time: rand(1..72)
                        }
                    }
                end
                
                dados_normalizados = normalizar_dados({
                    source: source,
                    data: data,
                    collected_at: collected_at
                })
                
                api_data = ApiData.create!(dados_normalizados)
                registros_fonte += 1
                sucessos += 1
                
                # Atualiza barra de progresso
                exibir_barra_progresso(i + 1, intervals, source)
            rescue => e
                erros += 1
                erros_fonte += 1
                puts "\n Erro ao processar #{source}: #{e.message}".colorize(:red)
            end
        end

        # Limpa a linha da barra de progresso
        print "\r" + (" " * 100) + "\r"
        
        # Exibe resumo da fonte
        puts "🟢 #{source} concluído: #{registros_fonte} registros criados".colorize(:green)
        puts " #{erros_fonte} erros encontrados".colorize(:red) if erros_fonte > 0
        puts "⚫ Tempo decorrido: #{(Time.now - start_time).round} segundos".colorize(:light_black)
    end

    # Adiciona alguns dados em tempo real (últimas 24h) para testes de dashboards
    puts "\nAdicionando dados recentes (últimas 24h) para testes de dashboards..."

    # Últimas 24 horas em intervalos de 1 hora
    24.times do |hour|
        collected_at = Time.now - hour.hours
        
        # Seleciona algumas fontes para ter dados mais recentes
        ["stock_market", "website_analytics", "sales_metrics"].each do |source|
            data = case source
            when "stock_market"
                # Dados de mercado de ações (mais voláteis em tempo real)
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
                # Dados de tráfego do site (em tempo real)
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
                # Vendas recentes
                {
                    revenue_last_hour: rand(1000..10000),
                    transactions_last_hour: rand(5..50),
                    conversion_rate: rand(1.0..10.0).round(2),
                    cart_abandonment: rand(40..80)
                }
            end
            
            api_data = ApiData.new(  # Corrigido de ApiDatum para ApiData
                source: source,
                data: data,
                collected_at: collected_at
            )
            
            api_data.save
        end
    end

    # Exibição do resumo final
    puts "\n=== Resumo da Operação ===".colorize(:blue)
    puts "🟢 Total de registros criados: #{sucessos}".colorize(:green)
    puts " Total de erros: #{erros}".colorize(:red) if erros > 0
    puts "⚫ Tempo total de execução: #{(Time.now - start_time).round} segundos".colorize(:light_black)

    # Informações de debug
    puts "\n🟣 Debug: Último registro em #{ApiData.maximum(:created_at)&.strftime('%d/%m/%Y %H:%M:%S')}".colorize(:magenta)
    
    # Verificação de fontes sem dados
    fontes_sem_dados = api_sources.select { |source| ApiData.where(source: source).count.zero? }
    if fontes_sem_dados.any?
        puts "\n🟡 Aviso: Fontes sem dados:".colorize(:yellow)
        fontes_sem_dados.each do |source|
            puts "  - #{source}".colorize(:yellow)
        end
    end

    puts "\n Processo de criação de dados de API concluído!".colorize(:blue)
rescue => e
    puts "\n Erro fatal durante a execução: #{e.message}".colorize(:red)
    puts "🟣 Debug: #{e.backtrace.first}".colorize(:magenta)
end