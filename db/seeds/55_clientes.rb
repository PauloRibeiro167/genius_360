puts "Criando clientes..."

# Limpa registros existentes
Cliente.destroy_all

# Nomes fictícios
nomes = [
  "João Silva", "Maria Oliveira", "Pedro Santos", "Ana Costa", "Carlos Souza",
  "Mariana Pereira", "José Rodrigues", "Fernanda Almeida", "Lucas Ferreira", "Juliana Lima",
  "Roberto Gomes", "Camila Martins", "Rafael Ribeiro", "Amanda Araújo", "Bruno Carvalho",
  "Patrícia Teixeira", "Gustavo Moreira", "Débora Barbosa", "Ricardo Cardoso", "Vanessa Correia",
  "Marcos Nascimento", "Letícia Fernandes", "Daniel Castro", "Cristina Lopes", "Alexandre Mendes",
  "Aline Dias", "Paulo Reis", "Bianca Campos", "Marcelo Pinto", "Tatiana Cavalcanti",
  "Victor Batista", "Renata Duarte", "Fábio Rocha", "Carla Pires", "Leonardo Freitas",
  "Natália Oliveira", "Gabriel Silva", "Isabela Machado", "Eduardo Santos", "Luiza Vieira",
  "Antônio Costa", "Carolina Moura", "Fernando Sousa", "Beatriz Azevedo", "Márcio Cunha",
  "Jéssica Nunes", "Guilherme Melo", "Eliana Borges", "Rodrigo Cardoso", "Daniela Ramos"
]

# CPFs fictícios (formato apenas para testes)
def gerar_cpf
  numeros = 9.times.map { rand(0..9) }
  
  # Cálculo do primeiro dígito verificador
  soma = 0
  9.times { |i| soma += numeros[i] * (10 - i) }
  resto = soma % 11
  primeiro_digito = resto < 2 ? 0 : 11 - resto
  
  # Cálculo do segundo dígito verificador
  soma = 0
  9.times { |i| soma += numeros[i] * (11 - i) }
  soma += primeiro_digito * 2
  resto = soma % 11
  segundo_digito = resto < 2 ? 0 : 11 - resto
  
  numeros.join + primeiro_digito.to_s + segundo_digito.to_s
end

# Gera 50 CPFs únicos
cpfs = []
50.times do
  cpf = gerar_cpf
  while cpfs.include?(cpf)
    cpf = gerar_cpf
  end
  cpfs << cpf
end

# Domínios de email
dominios = ["gmail.com", "hotmail.com", "yahoo.com.br", "outlook.com", "uol.com.br"]

# Prefixos de telefone
prefixos_telefone = ["11", "21", "31", "41", "51", "61", "71", "81", "91"]

# Endereços fictícios
ruas = ["Rua das Flores", "Av. Brasil", "Rua Santos Dumont", "Rua XV de Novembro", "Av. Paulista", 
        "Rua Marquês de Olinda", "Av. Atlântica", "Rua da Paz", "Av. Rio Branco", "Rua Amazonas"]
        
cidades = ["São Paulo", "Rio de Janeiro", "Belo Horizonte", "Curitiba", "Porto Alegre", 
           "Brasília", "Salvador", "Recife", "Fortaleza", "Manaus"]
           
estados = ["SP", "RJ", "MG", "PR", "RS", "DF", "BA", "PE", "CE", "AM"]

# Função para gerar timestamps aleatórios no último ano
def timestamp_aleatorio
  Time.now - rand(0..365) * 24 * 60 * 60
end

# Formatar nome para email válido
def nome_para_email(nome)
  # Remove acentos e caracteres especiais, mantém apenas letras e pontos
  nome_sem_acento = nome.downcase
                        .tr('áàãâäéèêëíìîïóòõôöúùûüçñ', 'aaaaaeeeeiiiioooooouuuucn')
                        .gsub(/[^a-z.]/, '.')
                        .gsub(/\.+/, '.')   # Substitui múltiplos pontos por um único
                        .gsub(/^\.|\.$/, '') # Remove pontos no início e fim
  nome_sem_acento
end

# Gera clientes ativos (40 clientes)
40.times do |i|
  nome = nomes[i]
  nome_normalizado = nome_para_email(nome)
  
  Cliente.create!(
    nome: nome,
    cpf: cpfs[i],
    email: "#{nome_normalizado}@#{dominios.sample}",
    telefone: "#{prefixos_telefone.sample}#{rand(9).to_s}#{rand(10000000..99999999)}",
    endereco: "#{ruas.sample}, #{rand(1..1000)}",
    cidade: cidades.sample,
    estado: estados.sample,
    cep: "#{rand(10000..99999)}-#{rand(100..999)}",
    observacoes: rand < 0.5 ? nil : "Cliente cadastrado no sistema em #{Time.now.strftime('%d/%m/%Y')}.",
    ativo: true,
    created_at: timestamp_aleatorio
  )
end

# Gera clientes inativos (10 clientes)
10.times do |i|
  nome = nomes[i + 40]
  nome_normalizado = nome_para_email(nome)
  
  Cliente.create!(
    nome: nome,
    cpf: cpfs[i + 40],
    email: "#{nome_normalizado}@#{dominios.sample}",
    telefone: "#{prefixos_telefone.sample}#{rand(9).to_s}#{rand(10000000..99999999)}",
    endereco: "#{ruas.sample}, #{rand(1..1000)}",
    cidade: cidades.sample,
    estado: estados.sample,
    cep: "#{rand(10000..99999)}-#{rand(100..999)}",
    observacoes: rand < 0.5 ? nil : "Cliente inativo desde #{Time.now.strftime('%d/%m/%Y')}.",
    ativo: false,
    created_at: timestamp_aleatorio
  )
end

puts "Criando variações para teste de robustez..."

# Cria alguns clientes sem telefone ou email para testar robustez
clientes = Cliente.all.to_a
5.times do
  if clientes.any?
    cliente = clientes.sample
    cliente.update(email: nil)
    clientes.delete(cliente)
  end
end

5.times do
  if clientes.any?
    cliente = clientes.sample
    cliente.update(telefone: nil)
    clientes.delete(cliente)
  end
end

# Marca alguns como "descartados" (soft deleted)
3.times do
  if clientes.any?
    cliente = clientes.sample
    if !cliente.discarded?
      cliente.discard
      clientes.delete(cliente)
    end
  end
end

puts "✓ #{Cliente.count} clientes criados"
puts "  → #{Cliente.kept.where(ativo: true).count} clientes ativos"
puts "  → #{Cliente.kept.where(ativo: false).count} clientes inativos"
puts "  → #{Cliente.discarded.count} clientes removidos (soft deleted)"
puts "  → #{Cliente.where(email: nil).count} clientes sem email"
puts "  → #{Cliente.where(telefone: nil).count} clientes sem telefone"