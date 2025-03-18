class Acompanhamento < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id lead data_acompanhamento resultado created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  belongs_to :lead, required: true
  belongs_to :user, optional: true
  
  validates :data_acompanhamento, presence: true
  validates :tipo_acompanhamento, presence: true
  
  scope :pendentes, -> { where(status: 'Pendente') }
  scope :concluidos, -> { where(status: 'Concluído') }
  scope :proximos, -> { where('proxima_data >= ?', Date.today).order(:proxima_data) }
  
  def self.tipo_options
    ['Ligação', 'Email', 'Reunião', 'Visita', 'Outro']
  end
  
  def self.status_options
    ['Pendente', 'Concluído', 'Cancelado']
  end

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
end
