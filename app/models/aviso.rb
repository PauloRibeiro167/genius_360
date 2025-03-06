class Aviso < ApplicationRecord
  has_and_belongs_to_many :users
  
  validates :titulo, presence: true
  validates :descricao, presence: true
end
