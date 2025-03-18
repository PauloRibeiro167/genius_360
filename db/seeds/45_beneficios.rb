def exibir_barra_progresso(atual, total, source)
  porcentagem = (atual.to_f / total * 100).round
  barras_preenchidas = (porcentagem / 5).round
  barra = "█" * barras_preenchidas + "░" * (20 - barras_preenchidas)
  print "\r Processando #{source}: [#{barra}] #{porcentagem}% (#{atual}/#{total})"
end

begin
  margem_padrao = 35.0
  margem_cartao = 5.0
  consignavel = true
  
  start_time = Time.current
  sucessos = 0
  erros = 0
  
  puts "\n Iniciando importação de benefícios..."
  puts " Arquivo: #45_beneficios.rb"

  beneficios_existentes = Beneficio.unscoped.pluck(:codigo)
  
  puts "\n Debug: Benefícios já cadastrados: #{beneficios_existentes.join(', ')}"

  categorias_beneficios = [
    {
    categoria: "INSS - Aposentadorias",
    beneficios: [
      {
      nome: "Aposentadoria por Idade Urbana",
      descricao: "Benefício concedido ao segurado urbano que comprovar idade mínima (65 anos homens, 62 anos mulheres) e tempo de contribuição.",
      codigo: 41
      },
      # ... [rest of the beneficios array remains unchanged]
    ]
    },
    # ... [rest of the categorias_beneficios array remains unchanged]
  ]

  total_categorias = categorias_beneficios.size
  total_beneficios = categorias_beneficios.sum { |c| c[:beneficios].size }

  puts "\n Total planejado: #{total_beneficios} benefícios em #{total_categorias} categorias"

  categorias_beneficios.each_with_index do |categoria, index|
    puts "\n Processando categoria: #{categoria[:categoria]} [#{index + 1}/#{total_categorias}]"
    
    categoria[:beneficios].each_with_index do |beneficio_data, ben_index|
      begin
        if beneficios_existentes.include?(beneficio_data[:codigo])
          puts "\n Benefício já existe: #{beneficio_data[:nome]} (#{beneficio_data[:codigo]})"
          next
        end

        beneficio = Beneficio.new(
          nome: beneficio_data[:nome],
          descricao: beneficio_data[:descricao],
          categoria: categoria[:categoria],
          codigo: beneficio_data[:codigo],
          margem_padrao: margem_padrao,
          margem_cartao_padrao: margem_cartao,
          consignavel: consignavel,
          ativo: true
        )
        
        if beneficio.save
          sucessos += 1
          puts "\n Criado: #{beneficio.codigo} - #{beneficio.nome}"
        else
          erros += 1
          puts "\n Erro: #{beneficio_data[:nome]} - #{beneficio.errors.full_messages.join(', ')}"
        end
      rescue => e
        erros += 1
        puts "\n Erro crítico com '#{beneficio_data[:nome]}': #{e.message}"
        puts " Debug: #{e.backtrace.first}"
      end

      exibir_barra_progresso(ben_index + 1, categoria[:beneficios].size, categoria[:categoria])
    end
    
    print "\r" + (" " * 100) + "\r"
    puts " Categoria concluída: #{categoria[:categoria]}"
  end

  puts "\n Criando benefícios descontinuados..."

  beneficios_descartados = [
    {
    nome: "Aposentadoria por Tempo de Serviço (Regra Antiga)",
    descricao: "Benefício concedido antes da reforma da previdência para segurados que comprovassem apenas tempo de serviço, sem requisito de idade mínima. Substituído pela aposentadoria por tempo de contribuição com regra de pontos."
    },
    # ... [rest of the beneficios_descartados array remains unchanged]
  ]

  beneficios_descartados.each_with_index do |beneficio_data, index|
    codigo = 8000 + index + 1
    
    if beneficios_existentes.include?(codigo)
      puts "\n Benefício descontinuado já existe: #{beneficio_data[:nome]} (#{codigo})"
      next
    end
    
    begin
      beneficio = Beneficio.create!(
        nome: beneficio_data[:nome],
        descricao: beneficio_data[:descricao],
        categoria: "Benefícios Descontinuados",
        codigo: codigo,
        margem_padrao: 0.0,
        margem_cartao_padrao: 0.0,
        consignavel: false,
        discarded_at: Time.current - rand(1..365).days,
        ativo: false
      )
      
      sucessos += 1
      puts "\n Criado benefício descontinuado: #{beneficio.codigo} - #{beneficio.nome}"
    rescue => e
      erros += 1
      puts "\n Erro ao criar #{beneficio_data[:nome]}: #{e.message}"
    end
  end

  puts "\n=== Resumo da Operação ==="
  puts " Benefícios criados com sucesso: #{sucessos}"
  puts " Total de erros encontrados: #{erros}" if erros > 0
  puts " Total atual no banco: #{Beneficio.unscoped.count}"
  puts " Tempo de execução: #{(Time.current - start_time).round} segundos"
  
  if sucessos == 0 && Beneficio.unscoped.count > 0
    puts "\n Aviso: Nenhum benefício novo foi criado pois todos já existem"
  end

rescue => e
  puts "\n Erro fatal durante a execução do seed de benefícios"
  puts " Causa: #{e.message}"
  puts " Local do erro: #{e.backtrace.first}"
  puts " Benefícios processados: #{sucessos} de #{total_beneficios}"
  puts " Tempo decorrido: #{(Time.current - start_time).round} segundos"
end
