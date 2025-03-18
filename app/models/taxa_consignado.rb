class TaxaConsignado < ApplicationRecord
  # Especifica o nome correto da tabela
  self.table_name = "taxas_consignados"

  # Validações
  validates :nome, presence: true
  validates :taxa_minima, :taxa_maxima, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :prazo_minimo, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :prazo_maximo, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :margem_emprestimo, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :margem_cartao, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :tipo_operacao, presence: true
  validates :data_vigencia_inicio, presence: true

  # Enums
  TIPOS_OPERACAO = ["Empréstimo", "Cartão", "Refinanciamento", "Portabilidade"]
  validates :tipo_operacao, inclusion: { in: TIPOS_OPERACAO }

  # Scopes
  scope :ativos, -> { where(ativo: true) }
  scope :vigentes, -> { 
    where(data_vigencia_fim: nil)
    .or(where('data_vigencia_fim >= ?', Date.current))
    .where('data_vigencia_inicio <= ?', Date.current)
  }
  scope :por_tipo_operacao, ->(tipo) { where(tipo_operacao: tipo) }

  # Soft Delete
  include Discard::Model
  default_scope -> { kept }
end