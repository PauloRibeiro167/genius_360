class Participante < ApplicationRecord
    # Relacionamentos
    belongs_to :reuniao
    belongs_to :user

    # Validações
    validates :reuniao_id, presence: true
    validates :user_id, presence: true
    validates :status, presence: true, 
        inclusion: { in: %w[pendente confirmado recusado] }
    validates :reuniao_id, uniqueness: { scope: :user_id }

    # Valores padrão
    attribute :status, :string, default: 'pendente'
end