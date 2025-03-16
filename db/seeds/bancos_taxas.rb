puts "Criando relações entre bancos e taxas de consignados..."

# Limpa registros existentes para evitar duplicações
# BancoTaxa.destroy_all (descomente se quiser limpar a tabela antes)

# Obtém os IDs existentes para criar relações válidas
bancos = Banco.all.index_by(&:numero_identificador)
taxas_consignados = TaxaConsignado.all.index_by(&:nome)

# Se não houver bancos ou taxas cadastradas, exibe um aviso
if bancos.empty? || taxas_consignados.empty?
  puts "ATENÇÃO: É necessário ter bancos e taxas de consignados cadastrados antes de executar esta seed."
  puts "Execute primeiro as seeds de bancos.rb e taxas_consignados.rb"
  exit
end

# Array de relações entre bancos e taxas com suas taxas preferenciais
relacoes = [
  # Banco do Brasil
  {
    banco_identificador: "001",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.670 # Taxa preferencial do banco para este tipo de consignado
  },
  {
    banco_identificador: "001",
    taxa_nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_preferencial: 1.530 # Taxa preferencial específica para servidores federais
  },
  {
    banco_identificador: "001",
    taxa_nome: "Refinanciamento Consignado - Padrão",
    taxa_preferencial: 1.540
  },
  
  # Caixa Econômica Federal
  {
    banco_identificador: "104",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.650
  },
  {
    banco_identificador: "104",
    taxa_nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_preferencial: 1.520
  },
  {
    banco_identificador: "104",
    taxa_nome: "Cartão Consignado - INSS",
    taxa_preferencial: 2.290
  },
  {
    banco_identificador: "104",
    taxa_nome: "Refinanciamento Consignado - Padrão",
    taxa_preferencial: 1.530
  },
  {
    banco_identificador: "104",
    taxa_nome: "Portabilidade Consignado - INSS",
    taxa_preferencial: 1.440
  },
  
  # Bradesco
  {
    banco_identificador: "237",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.680
  },
  {
    banco_identificador: "237",
    taxa_nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_preferencial: 1.550
  },
  {
    banco_identificador: "237",
    taxa_nome: "Cartão Consignado - INSS",
    taxa_preferencial: 2.320
  },
  
  # Itaú
  {
    banco_identificador: "341",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.675
  },
  {
    banco_identificador: "341",
    taxa_nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_preferencial: 1.540
  },
  {
    banco_identificador: "341",
    taxa_nome: "Empréstimo Consignado para Funcionários Privados",
    taxa_preferencial: 1.710
  },
  
  # Santander
  {
    banco_identificador: "033",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.675
  },
  {
    banco_identificador: "033",
    taxa_nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_preferencial: 1.545
  },
  {
    banco_identificador: "033",
    taxa_nome: "Refinanciamento Consignado - Padrão",
    taxa_preferencial: 1.545
  },
  {
    banco_identificador: "033",
    taxa_nome: "Portabilidade Consignado - INSS",
    taxa_preferencial: 1.445
  },
  
  # Banco Mercantil do Brasil (especialista em consignado)
  {
    banco_identificador: "389",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.660
  },
  {
    banco_identificador: "389",
    taxa_nome: "Portabilidade Consignado - INSS",
    taxa_preferencial: 1.430 # Taxa competitiva para portabilidade
  },
  
  # Banco Votorantim (BV)
  {
    banco_identificador: "655",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.670
  },
  {
    banco_identificador: "655",
    taxa_nome: "Portabilidade Consignado - INSS",
    taxa_preferencial: 1.440
  },
  
  # C6 Bank (banco digital)
  {
    banco_identificador: "336",
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.665
  },
  
  # Bancoob (Sicoob)
  {
    banco_identificador: "085",
    taxa_nome: "Empréstimo Consignado para Servidores Públicos Federais",
    taxa_preferencial: 1.530 # Taxa competitiva para cooperados
  },
  
  # Exemplo de relação inativa
  {
    banco_identificador: "735", # Banco Neon
    taxa_nome: "Empréstimo Consignado INSS",
    taxa_preferencial: 1.690,
    ativo: false,
    discarded_at: Date.today - 60.days
  }
]

# Cria as relações
contador_sucesso = 0
contador_erro = 0

relacoes.each do |rel|
  # Busca os registros de banco e taxa pelos identificadores
  banco = bancos[rel[:banco_identificador]]
  taxa = taxas_consignados[rel[:taxa_nome]]
  
  # Pula se não encontrar banco ou taxa
  unless banco && taxa
    puts "AVISO: Não foi possível encontrar banco '#{rel[:banco_identificador]}' ou taxa '#{rel[:taxa_nome]}'"
    contador_erro += 1
    next
  end
  
  # Parâmetros para o registro
  params = {
    banco_id: banco.id,
    taxa_consignado_id: taxa.id,
    taxa_preferencial: rel[:taxa_preferencial],
    ativo: rel.fetch(:ativo, true)
  }
  
  if rel[:discarded_at]
    params[:discarded_at] = rel[:discarded_at]
  end
  
  # Cria ou atualiza o registro
  banco_taxa = BancoTaxa.find_or_initialize_by(
    banco_id: banco.id,
    taxa_consignado_id: taxa.id
  )
  
  if banco_taxa.update(params)
    contador_sucesso += 1
    status = banco_taxa.ativo? ? "[ATIVO]" : "[INATIVO]"
    puts "Relacionado: #{banco.nome} -> #{taxa.nome} (#{rel[:taxa_preferencial]}%) #{status}"
  else
    contador_erro += 1
    puts "ERRO ao relacionar: #{banco.nome} -> #{taxa.nome}: #{banco_taxa.errors.full_messages.join(', ')}"
  end
end

puts "Relações entre bancos e taxas criadas com sucesso!"
puts "Total: #{contador_sucesso} relações criadas, #{contador_erro} erros"