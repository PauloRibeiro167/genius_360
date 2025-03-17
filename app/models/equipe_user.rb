class EquipeUser < ApplicationRecord
  self.table_name = 'equipes_users'
  
  belongs_to :equipe
  belongs_to :user

  validates :equipe_id, presence: true
  validates :user_id, presence: true
  validates :cargo, presence: true
  
  # Validação considerando o cargo
  validates :user_id, uniqueness: { 
    scope: [:equipe_id, :cargo],
    message: "já está associado a esta equipe com este cargo" 
  }
  
  # Opcional: Adicionar scope para facilitar consultas
  scope :ativos, -> { where(ativo: true) }
  scope :por_equipe, ->(equipe_id) { where(equipe_id: equipe_id) }
end