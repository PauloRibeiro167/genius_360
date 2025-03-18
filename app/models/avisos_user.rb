class AvisosUser < ApplicationRecord
  # Associações
  belongs_to :aviso
  belongs_to :user

  # Validações
  validates :aviso_id, presence: true
  validates :user_id, presence: true
  validates :aviso_id, uniqueness: { scope: :user_id, message: 'já está vinculado a este usuário' }
end