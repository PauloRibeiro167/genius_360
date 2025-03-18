puts "Criando associações entre Bancos e Taxas..."

# Primeiro, verificamos se temos bancos e taxas disponíveis
bancos = Banco.all
taxas_consignados = TaxaConsignado.all

if bancos.any? && taxas_consignados.any?
  # Para cada banco, vamos associar algumas taxas
  bancos.each do |banco|
    # Seleciona algumas taxas aleatoriamente para associar a este banco
    taxas_para_associar = taxas_consignados.sample(rand(1..5))
    
    taxas_para_associar.each do |taxa|
      # Cria uma taxa preferencial aleatória entre 0.1% e 2.5%
      taxa_preferencial = rand(0.1..2.5).round(3)
      
      BancoTaxa.create_or_find_by(
        banco: banco,
        taxa_consignado: taxa
      ) do |bt|
        bt.taxa_preferencial = taxa_preferencial
        bt.ativo = true
      end
      
      print "."
    end
  end
  
  puts "\nForam criadas #{BancoTaxa.count} associações entre bancos e taxas."
else
  puts "Não há bancos ou taxas cadastradas para criar associações."
end
