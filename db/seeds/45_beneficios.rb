puts "\nCriando registros de benefícios elegíveis para consignado bancário..."

# Categorias de benefícios por tipo de fonte pagadora
categorias_beneficios = [
  {
    categoria: "INSS - Aposentadorias",
    beneficios: [
      {
        nome: "Aposentadoria por Idade",
        descricao: "Benefício concedido ao segurado que comprovar idade mínima (65 anos homens, 62 anos mulheres) e tempo de contribuição. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      },
      {
        nome: "Aposentadoria por Tempo de Contribuição",
        descricao: "Benefício concedido pela regra de pontos (soma de idade e tempo de contribuição). Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      },
      {
        nome: "Aposentadoria por Invalidez",
        descricao: "Benefício concedido ao segurado que for considerado incapaz para trabalho e insuscetível de reabilitação. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      },
      {
        nome: "Aposentadoria Especial",
        descricao: "Benefício concedido ao segurado exposto a agentes nocivos à saúde por período prolongado. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      }
    ]
  },
  {
    categoria: "INSS - Pensões e Auxílios",
    beneficios: [
      {
        nome: "Pensão por Morte",
        descricao: "Benefício pago aos dependentes do segurado falecido. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      },
      {
        nome: "Auxílio-Doença (Benefício por Incapacidade Temporária)",
        descricao: "Benefício temporário concedido ao segurado impedido de trabalhar por doença ou acidente. Consignável apenas em casos específicos com restrições."
      },
      {
        nome: "Auxílio-Acidente",
        descricao: "Benefício pago ao trabalhador que sofre acidente e fica com sequelas permanentes. Permite consignado com margem de 35%, avaliado caso a caso."
      }
    ]
  },
  {
    categoria: "INSS - Benefícios Não Consignáveis",
    beneficios: [
      {
        nome: "BPC/LOAS",
        descricao: "Benefício de Prestação Continuada da Lei Orgânica da Assistência Social. Não permite operações de crédito consignado por lei."
      },
      {
        nome: "Auxílio-Reclusão",
        descricao: "Benefício pago aos dependentes de segurado preso. Não permite operações de crédito consignado."
      },
      {
        nome: "Salário-Maternidade",
        descricao: "Benefício pago durante a licença-maternidade. Não permite operações de crédito consignado por ser temporário."
      }
    ]
  },
  {
    categoria: "Servidores Públicos Federais",
    beneficios: [
      {
        nome: "Servidor Público Federal Ativo",
        descricao: "Salário de servidor federal em atividade. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão), conforme regulamentação específica."
      },
      {
        nome: "Aposentadoria Servidor Público Federal",
        descricao: "Provento de aposentadoria de servidor federal. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      },
      {
        nome: "Pensão Civil Federal",
        descricao: "Pensão paga a dependentes de servidor federal falecido. Permite consignado com margem de até 35% (30% empréstimo + 5% cartão)."
      }
    ]
  },
  {
    categoria: "Servidores Públicos Estaduais",
    beneficios: [
      {
        nome: "Servidor Público Estadual Ativo",
        descricao: "Salário de servidor estadual em atividade. Margem consignável varia conforme legislação específica de cada estado."
      },
      {
        nome: "Aposentadoria Servidor Público Estadual",
        descricao: "Provento de aposentadoria de servidor estadual. Margem consignável varia conforme legislação específica de cada estado."
      },
      {
        nome: "Pensão Civil Estadual",
        descricao: "Pensão paga a dependentes de servidor estadual falecido. Margem consignável varia conforme legislação específica de cada estado."
      }
    ]
  },
  {
    categoria: "Servidores Públicos Municipais",
    beneficios: [
      {
        nome: "Servidor Público Municipal Ativo",
        descricao: "Salário de servidor municipal em atividade. Margem consignável depende de convênio específico com cada município."
      },
      {
        nome: "Aposentadoria Servidor Público Municipal",
        descricao: "Provento de aposentadoria de servidor municipal. Margem consignável depende de convênio específico com cada município."
      },
      {
        nome: "Pensão Civil Municipal",
        descricao: "Pensão paga a dependentes de servidor municipal falecido. Margem consignável depende de convênio específico com cada município."
      }
    ]
  },
  {
    categoria: "Militares",
    beneficios: [
      {
        nome: "Militar Ativo - Exército",
        descricao: "Soldo de militar em atividade no Exército. Permite consignado conforme regras específicas das Forças Armadas."
      },
      {
        nome: "Militar Ativo - Marinha",
        descricao: "Soldo de militar em atividade na Marinha. Permite consignado conforme regras específicas das Forças Armadas."
      },
      {
        nome: "Militar Ativo - Aeronáutica",
        descricao: "Soldo de militar em atividade na Aeronáutica. Permite consignado conforme regras específicas das Forças Armadas."
      },
      {
        nome: "Militar Inativo (Reserva ou Reforma)",
        descricao: "Provento de militar na reserva ou reformado. Permite consignado conforme regras específicas das Forças Armadas."
      },
      {
        nome: "Pensão Militar",
        descricao: "Pensão paga a dependentes de militar falecido. Permite consignado conforme regras específicas das Forças Armadas."
      }
    ]
  },
  {
    categoria: "Funcionários de Empresas Privadas",
    beneficios: [
      {
        nome: "Funcionário CLT com Convênio",
        descricao: "Salário de funcionário regido pela CLT em empresa com convênio para desconto em folha. Margem varia conforme acordo entre empresa e instituição financeira."
      },
      {
        nome: "Trabalhador Temporário com Convênio",
        descricao: "Remuneração de trabalhador temporário em empresa com convênio. Geralmente não permitido devido à temporalidade do vínculo."
      }
    ]
  },
  {
    categoria: "Outros Benefícios Elegíveis",
    beneficios: [
      {
        nome: "FGTS - Saque Aniversário",
        descricao: "Antecipação do saque aniversário do FGTS para quem optou por esta modalidade. Permite até 7 parcelas anuais antecipadas."
      },
      {
        nome: "13º Salário (Aposentados e Pensionistas)",
        descricao: "Antecipação do 13º salário de aposentados e pensionistas do INSS. Disponível geralmente a partir de maio, apenas no ano corrente."
      }
    ]
  }
]

# Contador para acompanhamento
total_criados = 0
total_categorias = categorias_beneficios.size
total_beneficios = categorias_beneficios.sum { |c| c[:beneficios].size }

puts "Serão criados #{total_beneficios} tipos de benefícios em #{total_categorias} categorias..."

# Criação dos benefícios por categoria
categorias_beneficios.each_with_index do |categoria, index|
  puts "\n[#{index + 1}/#{total_categorias}] Categoria: #{categoria[:categoria]}"
  
  categoria[:beneficios].each do |beneficio_data|
    beneficio = Beneficio.new(
      nome: beneficio_data[:nome],
      descricao: beneficio_data[:descricao],
      categoria: categoria[:categoria]  # Adicionando a categoria
    )
    
    if beneficio.save
      total_criados += 1
      puts "  ✓ #{beneficio.nome}"
    else
      puts "  ✗ Erro ao criar '#{beneficio_data[:nome]}': #{beneficio.errors.full_messages.join(', ')}"
    end
  end
end

# Criar alguns benefícios que foram descontinuados ou alterados
beneficios_descartados = [
  {
    nome: "Aposentadoria por Tempo de Serviço (Regra Antiga)",
    descricao: "Benefício concedido antes da reforma da previdência para segurados que comprovassem apenas tempo de serviço, sem requisito de idade mínima. Substituído pela aposentadoria por tempo de contribuição com regra de pontos."
  },
  {
    nome: "Auxílio-Natalidade",
    descricao: "Antigo benefício pago pelo INSS em caso de nascimento de filho de segurado. Atualmente não é mais oferecido pelo INSS, sendo disponibilizado apenas em algumas previdências estaduais e municipais."
  },
  {
    nome: "Renda Mensal Vitalícia",
    descricao: "Benefício extinto com a criação do BPC/LOAS. Os beneficiários que já recebiam continuam com direito, e podem contratar consignado."
  }
]

puts "\nCriando benefícios descontinuados ou alterados (para histórico)..."

beneficios_descartados.each do |beneficio_data|
  beneficio = Beneficio.create(
    nome: beneficio_data[:nome],
    descricao: beneficio_data[:descricao],
    discarded_at: Time.current - rand(1..365).days
  )
  
  if beneficio.persisted?
    puts "✓ Benefício descartado: #{beneficio.nome}"
  else
    puts "✗ Erro ao criar benefício descartado: #{beneficio_data[:nome]}"
  end
end

# Resultado final
puts "\nProcesso de criação de benefícios concluído!"
puts "Total de benefícios elegíveis criados: #{total_criados}"
puts "Total de benefícios descontinuados: #{beneficios_descartados.size}"
puts "Total geral no banco de dados: #{Beneficio.unscoped.count}"

puts "\nImportante: Estes registros representam os tipos de benefícios elegíveis para consignado."
puts "Para associar estes benefícios a propostas ou clientes, utilize as tabelas de relacionamento adequadas."