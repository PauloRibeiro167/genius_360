# Exemplo de seed para hierarquias
hierarquias = [
  { nome: "Diretoria", nivel: 1, descricao: "Nível executivo" },
  { nome: "Gerência", nivel: 2, descricao: "Nível gerencial" },
  { nome: "Coordenação", nivel: 3, descricao: "Nível de coordenação" },
  { nome: "Operacional", nivel: 4, descricao: "Nível operacional" }
]

hierarquias.each do |h|
  Hierarquia.create!(h)
  puts "Hierarquia criada: #{h[:nome]}"
end