class Instituicao < ApplicationRecord
  self.table_name = "instituicoes"

  has_many :propostas
  validates :nome, presence: true
end
