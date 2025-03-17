class Proposta < ApplicationRecord
  
  validates :numero, presence: true
  validates :status, presence: true
end
