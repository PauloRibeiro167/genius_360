class Meta < ApplicationRecord
  include Discard::Model
  
  # Corrige o nome da tabela para o singular, já que a migration criou como 'meta'
  self.table_name = 'meta'
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição do enum para status - CORRIGIDO
  enum :status, {
    em_andamento: 'em andamento',
    concluida: 'concluída',   # Note o acento aqui
    nao_atingida: 'não atingida',
    superada: 'superada',
    cancelada: 'cancelada',
    pendente: 'pendente'
  }, default: 'em andamento'

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id tipo_meta valor_meta data_inicio data_fim status created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  # Corrigindo a associação para apontar para user em vez de usuario
  belongs_to :user, required: true

  # Callbacks para quando o registro é descartado/restaurado
  before_discard do
    # Adicione ações a serem executadas antes de descartar
  end

  after_discard do
    # Adicione ações a serem executadas após descartar
  end

  before_undiscard do
    # Adicione ações a serem executadas antes de restaurar
  end

  after_undiscard do
    # Adicione ações a serem executadas após restaurar
  end
  
  # Métodos auxiliares para verificar o status da meta
  def concluida?
    status == 'concluida'
  end
  
  def atrasada?
    status == 'atrasada' || (em_andamento? && data_fim < Date.today)
  end
  
  def proxima_de_vencer?
    em_andamento? && data_fim.between?(Date.today, Date.today + 7.days)
  end
  
  def progresso_percentual
    return 100 if concluida?
    return 0 if data_inicio > Date.today
    
    total_dias = (data_fim - data_inicio).to_i
    return 0 if total_dias <= 0
    
    dias_passados = (Date.today - data_inicio).to_i
    [[(dias_passados.to_f / total_dias * 100).round, 100].min, 0].max
  end
end
