begin
    start_time = Time.current
    sucessos = 0
    erros = 0
    
    puts "\n Iniciando importação de vínculos entre taxas e benefícios..."
    puts " Arquivo: #47_taxas_beneficios.rb"

    taxas_consignados = TaxaConsignado.all.index_by(&:nome)
    beneficios = Beneficio.all.index_by(&:codigo)

    if taxas_consignados.empty? || beneficios.empty?
        puts "\n ATENÇÃO: Dados prerequisitos não encontrados"
        puts " É necessário executar primeiro:"
        puts "   1. #46_taxas_consignados.rb"
        puts "   2. #45_beneficios.rb"
        exit
    end

    relacoes = [
        {
            taxa_consignado: "Empréstimo Consignado INSS",
            beneficio: 41,
            aplicavel: true,
            regras_especiais: "Limite de crédito calculado com base no histórico de benefícios"
        },
        {
            taxa_consignado: "Empréstimo Consignado INSS",
            beneficio: 32,
            aplicavel: true,
            regras_especiais: "Requer documentação médica adicional"
        },
        {
            taxa_consignado: "Empréstimo Consignado INSS",
            beneficio: 21,
            aplicavel: true,
            regras_especiais: nil
        },
        {
            taxa_consignado: "Empréstimo Consignado INSS",
            beneficio: 87,
            aplicavel: false,
            regras_especiais: "Não aplicável conforme regulamentação vigente"
        },
        {
            taxa_consignado: "Empréstimo Consignado para Servidores Públicos Federais",
            beneficio: 42,
            aplicavel: true,
            regras_especiais: "Taxa preferencial para servidores com mais de 10 anos de carreira"
        },
        {
            taxa_consignado: "Cartão Consignado - INSS",
            beneficio: 41,
            aplicavel: true,
            regras_especiais: "Limite de cartão de até 5% do benefício mensal"
        },
        {
            taxa_consignado: "Cartão Consignado - INSS",
            beneficio: 32,
            aplicavel: true,
            regras_especiais: "Limite de cartão de até 5% do benefício mensal"
        },
        {
            taxa_consignado: "Refinanciamento Consignado - Padrão",
            beneficio: 41,
            aplicavel: true,
            regras_especiais: "Permitido após quitação de 25% do contrato original"
        }
    ]

    puts "\n Serão processadas #{relacoes.size} relações entre taxas e benefícios"

    relacoes.each_with_index do |rel, index|
        taxa = taxas_consignados[rel[:taxa_consignado]]
        beneficio = beneficios[rel[:beneficio]]
        
        begin
            puts "\n Debug: Processando vínculo"
            puts " Taxa: #{rel[:taxa_consignado]} (#{taxa&.id})"
            puts " Benefício: #{rel[:beneficio]} (#{beneficio&.id})"
            
            if !taxa
                erros += 1
                puts "\n Taxa não encontrada: '#{rel[:taxa_consignado]}'"
                next
            end

            if !beneficio
                erros += 1
                puts "\n Benefício não encontrado. Código: #{rel[:beneficio]}"
                next
            end
            
            taxa_beneficio = TaxaBeneficio.find_or_initialize_by(
                taxa_consignado_id: taxa.id,
                beneficio_id: beneficio.id
            )
            
            if taxa_beneficio.update(
                aplicavel: rel[:aplicavel],
                regras_especiais: rel[:regras_especiais],
                ativo: true
            )
                sucessos += 1
                puts "\n Vínculo criado: #{taxa.nome} + Benefício #{beneficio.codigo}"
            else
                erros += 1
                puts "\n Erro ao salvar vínculo: #{taxa_beneficio.errors.full_messages.join(', ')}"
            end
        rescue => e
            erros += 1
            puts "\n Erro ao processar vínculo: #{e.message}"
            puts " Debug: #{e.backtrace.first}"
        end
    end

    print "\r" + (" " * 100) + "\r"

    if taxas_consignados["Taxa Antiga Inativa - INSS"] && beneficios["01"]
        begin
            taxa_inativa = taxas_consignados["Taxa Antiga Inativa - INSS"]
            beneficio = beneficios["01"]
            
            TaxaBeneficio.create!(
                taxa_consignado_id: taxa_inativa.id,
                beneficio_id: beneficio.id,
                aplicavel: false,
                regras_especiais: "Relação inativa - taxa descontinuada",
                ativo: false,
                discarded_at: Date.today - 30.days
            )
            
            puts " Vínculo inativo criado para demonstração"
            sucessos += 1
        rescue => e
            erros += 1
            puts " Erro ao criar vínculo inativo: #{e.message}"
        end
    end

    puts "\n=== Resumo da Operação ==="
    puts " Vínculos criados com sucesso: #{sucessos}"
    puts " Erros encontrados: #{erros}" if erros > 0
    puts " Total de vínculos no sistema: #{TaxaBeneficio.count}"
    puts " Tempo de execução: #{(Time.current - start_time).round} segundos"

rescue => e
    puts "\n Erro fatal durante a execução: #{e.message}"
    puts " Debug: #{e.backtrace.first}"
end
