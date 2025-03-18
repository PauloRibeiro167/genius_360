def exibir_barra_progresso(atual, total, source)
    porcentagem = (atual.to_f / total * 100).round
    barras_preenchidas = (porcentagem / 5).round
    barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
    print "\r Processando #{source}: [#{barra}] #{porcentagem}% (#{atual}/#{total})"
end

puts "\n Iniciando criação de taxas de consignados..."

begin
    start_time = Time.now
    sucessos = 0
    erros = 0
    
    data_hoje = Date.today
    
    taxas_array = [
        {
            nome: "Empréstimo Consignado INSS",
            taxa_minima: 1.680,
            taxa_maxima: 1.800,
            prazo_minimo: 12,
            prazo_maximo: 84,
            margem_emprestimo: 35.00,
            margem_cartao: 5.00,
            tipo_operacao: "Empréstimo",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: nil,
            ativo: true
        },
        {
            nome: "Empréstimo Consignado para Servidores Públicos Federais",
            taxa_minima: 1.550,
            taxa_maxima: 1.800,
            prazo_minimo: 12,
            prazo_maximo: 96,
            margem_emprestimo: 30.00,
            margem_cartao: 5.00,
            tipo_operacao: "Empréstimo",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: nil,
            ativo: true
        },
        {
            nome: "Empréstimo Consignado para Funcionários Privados",
            taxa_minima: 1.700,
            taxa_maxima: 3.000,
            prazo_minimo: 12,
            prazo_maximo: 48,
            margem_emprestimo: 30.00,
            margem_cartao: 5.00,
            tipo_operacao: "Empréstimo",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: nil,
            ativo: true
        },
        {
            nome: "Cartão Consignado - INSS",
            taxa_minima: 2.300,
            taxa_maxima: 2.830,
            prazo_minimo: 1,
            prazo_maximo: nil,
            margem_emprestimo: nil,
            margem_cartao: 5.00,
            tipo_operacao: "Cartão",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: nil,
            ativo: true
        },
        {
            nome: "Refinanciamento Consignado - Padrão",
            taxa_minima: 1.550,
            taxa_maxima: 1.900,
            prazo_minimo: 24,
            prazo_maximo: 96,
            margem_emprestimo: 35.00,
            margem_cartao: nil,
            tipo_operacao: "Refinanciamento",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: nil,
            ativo: true
        },
        {
            nome: "Portabilidade Consignado - INSS",
            taxa_minima: 1.450,
            taxa_maxima: 1.780,
            prazo_minimo: 12,
            prazo_maximo: 84,
            margem_emprestimo: 35.00,
            margem_cartao: nil,
            tipo_operacao: "Portabilidade",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: nil,
            ativo: true
        },
        {
            nome: "Taxa Especial Promocional - Servidor Público",
            taxa_minima: 1.400,
            taxa_maxima: 1.650,
            prazo_minimo: 12,
            prazo_maximo: 60,
            margem_emprestimo: 30.00,
            margem_cartao: nil,
            tipo_operacao: "Empréstimo",
            data_vigencia_inicio: data_hoje,
            data_vigencia_fim: data_hoje + 90.days,
            ativo: true
        },
        {
            nome: "Taxa Antiga Inativa - INSS",
            taxa_minima: 1.660,
            taxa_maxima: 1.960,
            prazo_minimo: 12,
            prazo_maximo: 72,
            margem_emprestimo: 35.00,
            margem_cartao: nil,
            tipo_operacao: "Empréstimo",
            data_vigencia_inicio: data_hoje - 365.days,
            data_vigencia_fim: data_hoje - 30.days,
            ativo: false,
            discarded_at: data_hoje - 30.days
        }
    ]
    
    total_taxas = taxas_array.size
    
    puts " Total de taxas a serem processadas: #{total_taxas}"
    
    taxas_array.each_with_index do |taxa_attrs, index|
        begin
            taxa = TaxaConsignado.find_or_initialize_by(nome: taxa_attrs[:nome])
            taxa.assign_attributes(taxa_attrs)
            
            if taxa.save
                sucessos += 1
                exibir_barra_progresso(index + 1, total_taxas, "Taxas de Consignado")
            end
        rescue => e
            erros += 1
            puts "\n Erro ao criar taxa '#{taxa_attrs[:nome]}': #{e.message}"
            puts " Debug: #{e.backtrace.first}"
        end
    end
    
    print "\r" + (" " * 100) + "\r"
    
    puts "\n=== Resumo da Operação ==="
    puts " Total de taxas criadas com sucesso: #{sucessos}"
    puts " Total de erros: #{erros}" if erros > 0
    puts " Tempo total de execução: #{(Time.now - start_time).round} segundos"
    
    if erros.zero?
        puts " Todas as taxas foram criadas com sucesso!"
    else
        puts " Algumas taxas não puderam ser criadas. Verifique os erros acima."
    end
    
rescue => e
    puts "\n Erro fatal durante a execução: #{e.message}"
    puts " Debug: #{e.backtrace.first}"
end
