class Cliente < ApplicationRecord
  include Discard::Model
  self.discard_column = :discarded_at

  # Validações
  validates :nome, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  
  # Escopos
  scope :ativos, -> { where(ativo: true) }
  scope :inativos, -> { where(ativo: false) }
  scope :ordenado_por_nome, -> { order(nome: :asc) }
  scope :search, ->(termo) { where("nome ILIKE ? OR cpf ILIKE ? OR email ILIKE ?", "%#{termo}%", "%#{termo}%", "%#{termo}%") }
  
  # Callbacks
  before_save :formatar_cpf
  
  def endereco_completo
    [endereco, cidade, estado, cep].compact.join(', ')
  end
  
  private
  
  def formatar_cpf
    # Remove caracteres não numéricos
    self.cpf = cpf.gsub(/[^\d]/, '') if cpf.present?
  end
end