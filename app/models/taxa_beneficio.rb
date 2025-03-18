class TaxaBeneficio < ApplicationRecord
  # Nome correto da tabela
  self.table_name = "taxas_beneficios"

  # Relacionamentos
  belongs_to :taxa_consignado
  belongs_to :beneficio

  # Validações
  validates :taxa_consignado, presence: true
  validates :beneficio, presence: true
  validates :beneficio_id, uniqueness: { scope: :taxa_consignado_id, 
    message: "já possui uma taxa associada para este benefício" }

  # Soft Delete (usando a gem discard)
  include Discard::Model
  default_scope -> { kept }

  # Scopes
  scope :ativos, -> { where(ativo: true) }
  scope :aplicaveis, -> { where(aplicavel: true) }
  scope :por_beneficio, ->(beneficio_id) { where(beneficio_id: beneficio_id) }
  scope :por_taxa_consignado, ->(taxa_id) { where(taxa_consignado_id: taxa_id) }

  # Callbacks
  before_save :verificar_regras_especiais

  private

  def verificar_regras_especiais
    # Garante que regras_especiais seja nil se estiver vazio
    self.regras_especiais = nil if regras_especiais.blank?
  end
end