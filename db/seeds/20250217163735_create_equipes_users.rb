puts "Associando usuários às equipes..."

# Limpa registros existentes para evitar duplicações
# EquipeUser.destroy_all (descomente se quiser limpar a tabela antes)

# Verifica se existem usuários e equipes no sistema
usuarios = User.all
equipes = Equipe.all

if usuarios.empty?
  puts "ATENÇÃO: Não existem usuários cadastrados. Execute primeiro a seed de usuários."
  exit
end

if equipes.empty?
  puts "ATENÇÃO: Não existem equipes cadastradas. Execute primeiro a seed de equipes."
  exit
end

# Cargos possíveis nas equipes
cargos = [
  "Vendedor", 
  "Supervisor", 
  "Gerente", 
  "Analista", 
  "Assistente", 
  "Coordenador", 
  "Consultor"
]

# Data atual para referência
data_atual = Date.today

# Contador de associações
associacoes_criadas = 0

# Distribui usuários entre as equipes
# Cada usuário pode estar em 1 ou 2 equipes
usuarios.each do |usuario|
  # Quantidade de equipes que o usuário participa (1 ou 2, com maior probabilidade de 1)
  quantidade_equipes = rand < 0.3 ? 2 : 1
  
  # Seleciona equipes aleatórias para o usuário
  equipes_do_usuario = equipes.where(ativo: true).sample(quantidade_equipes)
  
  equipes_do_usuario.each do |equipe|
    # Para líderes de equipe, atribuir cargo de Gerente ou Supervisor
    if equipe.lider_id == usuario.id
      cargo = ["Gerente", "Supervisor"].sample
    else
      cargo = cargos.sample
    end
    
    # Data de entrada (entre 1 ano atrás e hoje)
    data_entrada = rand(365).days.ago
    
    # Data de saída (nil para membros ativos, data no passado para inativos)
    data_saida = rand < 0.9 ? nil : rand(30..90).days.ago
    
    # Define se o membro está ativo
    ativo = data_saida.nil?
    
    # Meta individual (valor entre 10.000 e 50.000)
    meta_individual = rand(10000..50000)
    
    # Cria a associação
    associacao = EquipeUser.find_or_initialize_by(
      equipe_id: equipe.id,
      user_id: usuario.id
    )
    
    if associacao.new_record? || associacao.data_saida.present?
      associacao.update!(
        cargo: cargo,
        data_entrada: data_entrada,
        data_saida: data_saida,
        ativo: ativo,
        meta_individual: meta_individual,
        discarded_at: data_saida # Se saiu da equipe, marca como descartado
      )
      
      associacoes_criadas += 1
      status = ativo ? "[ATIVO]" : "[INATIVO]"
      puts "#{usuario.email} associado à equipe #{equipe.nome} como #{cargo} #{status}"
    end
  end
end

# Cria algumas associações específicas para demonstração
if equipes.where(ativo: true).count >= 2 && usuarios.count >= 5
  # Seleciona duas equipes ativas
  equipe_vendas = equipes.find_by(tipo_equipe: "Vendas", ativo: true)
  equipe_adm = equipes.find_by(tipo_equipe: "Administrativo", ativo: true)
  
  if equipe_vendas && equipe_adm
    # Seleciona alguns usuários para fazer parte de ambas as equipes
    usuarios_multi_equipe = usuarios.sample(2)
    
    usuarios_multi_equipe.each do |usuario|
      # Associa à equipe de vendas
      EquipeUser.create!(
        equipe_id: equipe_vendas.id,
        user_id: usuario.id,
        cargo: "Vendedor",
        data_entrada: 6.months.ago,
        ativo: true,
        meta_individual: 40000
      )
      
      # Associa à equipe administrativa
      EquipeUser.create!(
        equipe_id: equipe_adm.id,
        user_id: usuario.id,
        cargo: "Assistente",
        data_entrada: 3.months.ago,
        ativo: true,
        meta_individual: 20000
      )
      
      associacoes_criadas += 2
      puts "#{usuario.email} associado a múltiplas equipes para demonstração"
    end
  end
end

puts "Total de associações criadas: #{associacoes_criadas}"
puts "Usuários associados às equipes com sucesso!"