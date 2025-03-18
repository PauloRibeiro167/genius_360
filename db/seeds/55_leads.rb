puts "Criando leads para demonstração..."

# Encontra um usuário para associar aos leads
user = User.first

if user.nil?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

# Removendo a verificação de instituição, já que não parece ser necessária conforme a migration
# (A tabela instituicoes não existe segundo o erro)

# Criando uma variável para armazenar os dados dos leads
leads_data = [
  { 
    nome: 'Maria Silva', 
    email: 'maria@empresa.com.br', 
    telefone: '(11) 98765-4321',
    empresa: 'Empresa ABC Ltda',
    cargo: 'Diretora Comercial',
    origem: 'Site',
    status: 'Qualificado',
    observacao: 'Cliente interessado em nossos serviços de consultoria.',
    user_id: user.id,
    data_contato: Date.today - 10.days,
    ativo: true,
    potencial_venda: 35000.00
  },
  { 
    nome: 'João Santos', 
    email: 'joao@corporacao.com', 
    telefone: '(21) 99876-5432',
    empresa: 'Corporação XYZ',
    cargo: 'Gerente de TI',
    origem: 'Indicação',
    status: 'Em contato',
    observacao: 'Precisa de uma solução completa para departamento de TI.',
    user_id: user.id,
    data_contato: Date.today - 5.days,
    ativo: true,
    potencial_venda: 75000.00
  },
  { 
    nome: 'Ana Oliveira', 
    email: 'ana@startupnova.com', 
    telefone: '(31) 97654-3210',
    empresa: 'Startup Nova',
    cargo: 'CEO',
    origem: 'Evento',
    status: 'Proposta',
    observacao: 'Startup em crescimento com necessidade de escalar operações.',
    user_id: user.id,
    data_contato: Date.today - 2.days,
    ativo: true,
    potencial_venda: 50000.00
  },
  { 
    nome: 'Carlos Mendes', 
    email: 'carlos@tradicional.com.br', 
    telefone: '(41) 98765-0987',
    empresa: 'Indústria Tradicional S.A.',
    cargo: 'Diretor de Operações',
    origem: 'Email Marketing',
    status: 'Negociação',
    observacao: 'Empresa tradicional buscando modernização dos processos.',
    user_id: user.id,
    data_contato: Date.today - 15.days,
    ativo: true,
    potencial_venda: 120000.00
  },
  { 
    nome: 'Paula Ferreira', 
    email: 'paula@tecnologia.com', 
    telefone: '(51) 98877-6655',
    empresa: 'Tecnologia Avançada Ltda',
    cargo: 'CTO',
    origem: 'Redes Sociais',
    status: 'Novo',
    observacao: 'Interessada em soluções de automação industrial.',
    user_id: user.id,
    data_contato: Date.today - 1.days,
    ativo: true,
    potencial_venda: nil
  }
]

count = 0
leads_data.each do |lead_data|
  if Lead.find_by(email: lead_data[:email]).nil?
    lead = Lead.create!(lead_data)
    puts "Lead #{lead.nome} criado com sucesso!"
    count += 1
  else
    puts "Lead com email #{lead_data[:email]} já existe. Pulando..."
  end
end

puts "Concluído! #{count} leads cadastrados."