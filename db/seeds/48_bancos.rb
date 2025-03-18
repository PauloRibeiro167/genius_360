def dados_bancos
    [
        {
            numero_identificador: "001",
            nome: "Banco do Brasil",
            descricao: "Banco do Brasil S.A. - Banco estatal de economia mista",
            site: "https://www.bb.com.br",
            regras_gerais: "Taxa de juros competitiva para empréstimo consignado, disponível para aposentados e pensionistas do INSS e servidores públicos federais."
        },
        {
            numero_identificador: "033",
            nome: "Santander",
            descricao: "Banco Santander Brasil S.A. - Banco privado de origem espanhola",
            site: "https://www.santander.com.br",
            regras_gerais: "Oferece empréstimo consignado para aposentados, pensionistas do INSS e servidores públicos. Possibilidade de portabilidade de dívidas."
        },
        {
            numero_identificador: "104",
            nome: "Caixa Econômica Federal",
            descricao: "Caixa Econômica Federal - Banco estatal",
            site: "https://www.caixa.gov.br",
            regras_gerais: "Principal agente de crédito consignado do país. Atende aposentados e pensionistas do INSS, servidores públicos federais, estaduais e municipais."
        },
        {
            numero_identificador: "237",
            nome: "Bradesco",
            descricao: "Banco Bradesco S.A. - Banco privado brasileiro",
            site: "https://www.bradesco.com.br",
            regras_gerais: "Consignado disponível para aposentados e pensionistas do INSS, servidores públicos e empresas conveniadas."
        },
        {
            numero_identificador: "341",
            nome: "Itaú",
            descricao: "Banco Itaú S.A. - Banco privado brasileiro",
            site: "https://www.itau.com.br",
            regras_gerais: "Oferece empréstimo consignado com taxas atrativas para aposentados e pensionistas do INSS e servidores públicos."
        },
        {
            numero_identificador: "389",
            nome: "Banco Mercantil do Brasil",
            descricao: "Banco Mercantil do Brasil S.A. - Banco privado brasileiro",
            site: "https://www.mercantil.com.br",
            regras_gerais: "Especialista em crédito consignado para aposentados e pensionistas do INSS."
        },
        {
            numero_identificador: "085",
            nome: "Bancoob (Sicoob)",
            descricao: "Banco Cooperativo do Brasil - Sistema cooperativo",
            site: "https://www.sicoob.com.br",
            regras_gerais: "Oferece empréstimo consignado para funcionários públicos e aposentados com condições especiais para cooperados."
        },
        {
            numero_identificador: "756",
            nome: "Bansicredi (Sicredi)",
            descricao: "Banco Cooperativo Sicredi - Sistema cooperativo",
            site: "https://www.sicredi.com.br",
            regras_gerais: "Oferece consignado para servidores públicos e aposentados com taxas diferenciadas para associados."
        },
        {
            numero_identificador: "655",
            nome: "Banco Votorantim",
            descricao: "Banco Votorantim S.A. (BV) - Banco privado brasileiro",
            site: "https://www.bv.com.br",
            regras_gerais: "Especializado em consignado para aposentados e pensionistas do INSS, com opções de portabilidade."
        },
        {
            numero_identificador: "336",
            nome: "Banco C6 S.A.",
            descricao: "Banco digital brasileiro",
            site: "https://www.c6bank.com.br",
            regras_gerais: "Oferece empréstimo consignado digital para aposentados e pensionistas do INSS com processo simplificado."
        },
        {
            numero_identificador: "212",
            nome: "Banco Original",
            descricao: "Banco digital brasileiro",
            site: "https://www.original.com.br",
            regras_gerais: "Oferece consignado para aposentados e pensionistas do INSS com processo 100% digital."
        },
        {
            numero_identificador: "735",
            nome: "Banco Neon",
            descricao: "Banco digital brasileiro",
            site: "https://www.neon.com.br",
            regras_gerais: "Oferece consignado para grupos específicos de servidores públicos e aposentados do INSS.",
            discarded_at: Time.now - 60.days
        }
    ]
end

begin
    start_time = Time.now
    total_bancos = dados_bancos.length
    sucessos = 0
    erros = 0
    
    puts "Iniciando cadastro de bancos..."
    puts "Total de registros a processar: #{total_bancos}"

    dados_bancos.each do |banco_attrs|
        begin
            banco = Banco.find_or_initialize_by(numero_identificador: banco_attrs[:numero_identificador])
            banco.assign_attributes(banco_attrs)
            
            if banco.save
                sucessos += 1
            else
                erros += 1
                puts "Erro de validação: #{banco.errors.full_messages.join(', ')}"
            end
            
        rescue => e
            erros += 1
            puts "Erro ao processar #{banco_attrs[:nome]}: #{e.message}"
        end
    end
    
    puts "Bancos processados com sucesso: #{sucessos}"
    puts "Total de erros encontrados: #{erros}" if erros > 0
    puts "Bancos ativos no sistema: #{Banco.kept.count}"
    puts "Tempo de execução: #{(Time.now - start_time).round}s"

rescue => e
    puts "Erro fatal durante execução:"
    puts "#{e.message}"
end
