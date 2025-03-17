class Disponibilidade < ApplicationRecord
    # Relacionamentos
    belongs_to :user

    # Validações
    validates :dia_semana, presence: true,
              inclusion: { 
                in: %w[segunda-feira terca-feira quarta-feira quinta-feira sexta-feira],
                message: "deve ser um dia útil válido" 
              }
    validates :hora_inicio, presence: true
    validates :hora_fim, presence: true
    validates :disponivel, inclusion: { in: [true, false] }
    
    # Validação personalizada para hora_fim maior que hora_inicio
    validate :hora_fim_depois_de_hora_inicio
    
    # Scopes
    scope :disponiveis, -> { where(disponivel: true) }
    scope :por_dia, ->(dia) { where(dia_semana: dia) }
    
    private
    
    def hora_fim_depois_de_hora_inicio
        return if hora_inicio.blank? || hora_fim.blank?
        
        if hora_fim <= hora_inicio
            errors.add(:hora_fim, "deve ser posterior à hora de início")
        end
    end
end