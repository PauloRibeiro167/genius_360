class Reuniao < ApplicationRecord
    include Discard::Model
    
    # Relacionamentos
    belongs_to :organizador, class_name: 'User'
    has_many :participantes, dependent: :destroy
    has_many :users, through: :participantes
    has_one_attached :memorando_pdf

    # Validações
    validates :titulo, presence: true
    validates :descricao, presence: true
    validates :data_inicio, presence: true
    validates :data_fim, presence: true
    validates :status, presence: true, 
              inclusion: { in: %w[agendada confirmada cancelada finalizada] }
    
    # Validação personalizada para data_fim maior que data_inicio
    validate :data_fim_depois_de_data_inicio
    validate :participantes_disponiveis?

    # Scopes
    default_scope -> { kept }
    scope :agendadas, -> { where(status: 'agendada') }
    scope :confirmadas, -> { where(status: 'confirmada') }
    scope :canceladas, -> { where(status: 'cancelada') }
    scope :finalizadas, -> { where(status: 'finalizada') }
    scope :futuras, -> { where('data_inicio > ?', Time.current) }
    scope :passadas, -> { where('data_fim < ?', Time.current) }

    private

    def data_fim_depois_de_data_inicio
        return if data_inicio.blank? || data_fim.blank?

        if data_fim < data_inicio
            errors.add(:data_fim, "deve ser posterior à data de início")
        end
    end

    def participantes_disponiveis?
        dia_semana = data_inicio.strftime("%A").downcase
        hora_inicio = data_inicio.strftime("%H:%M")
        hora_fim = data_fim.strftime("%H:%M")

        participantes.each do |participante|
            disponibilidade = participante.user.disponibilidades.find_by(dia_semana: dia_semana)
            
            unless disponibilidade&.disponivel_no_horario?(hora_inicio, hora_fim)
                errors.add(:base, "#{participante.user.nome} não está disponível neste horário")
            end
        end
    end
end
