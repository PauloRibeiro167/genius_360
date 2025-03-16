puts "Criando registros de bancos..."

# Limpa registros existentes para evitar duplicações
# Banco.destroy_all (descomente se quiser limpar a tabela antes)

# Array com os principais bancos brasileiros que operam com consignados
bancos = [
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
    descartado_em: Time.now - 60.days
  }
]

# Cria ou atualiza os registros de bancos
bancos.each do |banco_attrs|
  banco = Banco.find_or_initialize_by(numero_identificador: banco_attrs[:numero_identificador])
  banco.assign_attributes(banco_attrs)
  banco.save!
  puts "Banco #{banco.nome} (#{banco.numero_identificador}) " + (banco.descartado_em.present? ? "[INATIVO]" : "[ATIVO]")
end

puts "Bancos cadastrados com sucesso! Total: #{Banco.count} (#{Banco.where(descartado_em: nil).count} ativos)"