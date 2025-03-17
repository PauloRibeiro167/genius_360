class Hierarquia < ApplicationRecord
  # Define explicitamente o nome da tabela
  self.table_name = "hierarquias"

  # Validações
  validates :nome, presence: true, uniqueness: true
  validates :nivel, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  validates :ativo, inclusion: [true, false]

  # Soft delete
  include Discard::Model
  default_scope -> { kept }
  
  # Relacionamentos
  has_many :users, dependent: :restrict_with_error
  
  # Escopos
  default_scope { order(nivel: :asc) }
  scope :ativos, -> { where(ativo: true) }
  scope :kept, -> { undiscarded }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id nome nivel created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[users]
  end

  # Callbacks
  before_discard :verificar_dependencias
  after_discard :registrar_descarte
  before_undiscard :verificar_restauracao
  after_undiscard :registrar_restauracao

  private

  def verificar_dependencias
    return unless users.exists?
    errors.add(:base, 'Não é possível descartar uma hierarquia com usuários associados')
    throw :abort
  end

  def registrar_descarte
    Rails.logger.info "Hierarquia #{id} - #{nome} foi descartada em #{Time.current}"
  end

  def verificar_restauracao
    # Adicione lógica de verificação se necessário
  end

  def registrar_restauracao
    Rails.logger.info "Hierarquia #{id} - #{nome} foi restaurada em #{Time.current}"
  end

  # Métodos auxiliares
  def to_s
    "#{nome} (Nível #{nivel})"
  end
end
