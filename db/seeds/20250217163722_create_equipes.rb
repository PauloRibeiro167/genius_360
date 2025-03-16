puts "Criando equipes de trabalho..."

# Limpa registros existentes para evitar duplicações
# Equipe.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários no sistema para associar como líderes
usuarios = User.all
if usuarios.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  puts "Criando equipes sem líderes definidos."
end

# Tipos possíveis de equipes
tipos_equipe = [
  "Vendas", 
  "Atendimento", 
  "Financeiro", 
  "Administrativo", 
  "Operacional"
]

# Regiões de atuação
regioes = [
  "Norte", 
  "Nordeste", 
  "Centro-Oeste", 
  "Sudeste", 
  "Sul", 
  "Nacional"
]

# Dados das equipes
equipes = [
  {
    nome: "Equipe Alfa",
    descricao: "Equipe principal de vendas para região Sudeste",
    tipo_equipe: "Vendas",
    regiao_atuacao: "Sudeste"
  },
  {
    nome: "Equipe Beta",
    descricao: "Equipe de vendas focada na região Sul",
    tipo_equipe: "Vendas",
    regiao_atuacao: "Sul"
  },
  {
    nome: "Equipe Gama",
    descricao: "Equipe de atendimento ao cliente",
    tipo_equipe: "Atendimento",
    regiao_atuacao: "Nacional"
  },
  {
    nome: "Equipe Operações Norte",
    descricao: "Equipe operacional para a região Norte",
    tipo_equipe: "Operacional",
    regiao_atuacao: "Norte"
  },
  {
    nome: "Equipe Financeira",
    descricao: "Equipe responsável pelo financeiro da empresa",
    tipo_equipe: "Financeiro",
    regiao_atuacao: "Nacional"
  },
  {
    nome: "Equipe Administrativa",
    descricao: "Equipe de suporte administrativo",
    tipo_equipe: "Administrativo",
    regiao_atuacao: "Nacional"
  },
  {
    nome: "Equipe Nordeste",
    descricao: "Equipe de vendas focada na região Nordeste",
    tipo_equipe: "Vendas",
    regiao_atuacao: "Nordeste"
  },
  {
    nome: "Equipe Centro-Oeste",
    descricao: "Equipe de vendas focada na região Centro-Oeste",
    tipo_equipe: "Vendas",
    regiao_atuacao: "Centro-Oeste"
  }
]

# Cria as equipes
equipes_criadas = 0

equipes.each_with_index do |equipe_attrs, index|
  # Seleciona um usuário como líder (se houver usuários)
  lider = usuarios[index % usuarios.count] if usuarios.present?
  
  equipe = Equipe.find_or_initialize_by(nome: equipe_attrs[:nome])
  equipe.update!(
    descricao: equipe_attrs[:descricao],
    lider: lider,
    tipo_equipe: equipe_attrs[:tipo_equipe],
    regiao_atuacao: equipe_attrs[:regiao_atuacao],
    ativo: true
  )
  
  equipes_criadas += 1
  puts "Equipe criada: #{equipe.nome} (#{equipe.tipo_equipe} - #{equipe.regiao_atuacao})"
end

# Cria uma equipe inativa para demonstrar soft delete
if usuarios.present?
  equipe_inativa = Equipe.create!(
    nome: "Equipe Legado",
    descricao: "Equipe descontinuada após reestruturação",
    lider: usuarios.last,
    tipo_equipe: "Vendas",
    regiao_atuacao: "Nacional",
    ativo: false,
    discarded_at: 3.months.ago
  )
  
  equipes_criadas += 1
  puts "Equipe inativa criada: #{equipe_inativa.nome} [INATIVA]"
end

puts "Total de equipes criadas: #{equipes_criadas}"
puts "Equipes criadas com sucesso!"