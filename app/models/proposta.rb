class Proposta < ApplicationRecord
  self.table_name = 'propostas'
  
  validates :numero, presence: true
  validates :status, presence: true
end
