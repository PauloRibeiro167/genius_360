class Equipe < ApplicationRecord
  # Relacionamentos
  belongs_to :lider, class_name: 'User', optional: true
  has_many :equipes_users, dependent: :destroy
  has_many :users, through: :equipes_users

  # Validações
  validates :nome, presence: true, uniqueness: true
  validates :descricao, presence: true
  validates :ativo, inclusion: [true, false]

  # Soft Delete
  include Discard::Model
  default_scope -> { kept }

  # Scopes
  scope :ativas, -> { where(ativo: true) }
  
  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id nome descricao created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[lider users equipes_users]
  end

  # Callbacks
  before_discard :verificar_dependencias
  after_discard :registrar_descarte

  private

  def verificar_dependencias
    if users.exists?
      errors.add(:base, 'Não é possível descartar uma equipe com usuários associados')
      throw :abort
    end
  end

  def registrar_descarte
    Rails.logger.info "Equipe #{id} - #{nome} foi descartada em #{Time.current}"
  end
end