class BancoTaxa < ApplicationRecord
  include Discard::Model
  
  belongs_to :banco
  belongs_to :taxa_consignado
  
  validates :banco_id, presence: true
  validates :taxa_consignado_id, presence: true
  validates :banco_id, uniqueness: { scope: :taxa_consignado_id, message: "já possui essa taxa associada" }
  
  validates :taxa_preferencial, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :ativos, -> { where(ativo: true) }
  scope :inativos, -> { where(ativo: false) }
end
