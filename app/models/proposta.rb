class Proposta < ApplicationRecord
  # Define o nome da tabela
  self.table_name = 'propostas'

  # Soft Delete
  include Discard::Model
  default_scope -> { kept }

  # Enums
  enum :status, {
    'pre_digitacao': 'pre_digitacao',
    'rascunho': 'rascunho',
    'em_digitacao': 'em_digitacao',
    'aguardando_documentos': 'aguardando_documentos',
    'em_analise': 'em_analise',
    'em_analise_credito': 'em_analise_credito',
    'pendente_conformidade': 'pendente_conformidade',
    'aprovada': 'aprovada',
    'rejeitada': 'rejeitada',
    'cancelada': 'cancelada',
    'em_formalizacao': 'em_formalizacao',
    'formalizada': 'formalizada'
  }

  # Validações
  validates :numero, presence: true, 
                    uniqueness: true, 
                    format: { with: /\A\d{4}\.\d{2}\.\d{6}\z/, 
                             message: "deve seguir o formato AAAA.MM.XXXXXX" }
  
  validates :status, presence: true,
                    inclusion: { in: statuses.keys }

  # Callbacks
  before_validation :gerar_numero, on: :create

  # Scopes
  scope :ativos, -> { where.not(status: [:cancelada, :rejeitada]) }
  scope :em_andamento, -> { where(status: [:rascunho, :em_analise]) }
  scope :finalizadas, -> { where(status: [:aprovada, :rejeitada, :cancelada]) }

  private

  def gerar_numero
    return if numero.present?
    
    ultimo_numero = Proposta.where("numero LIKE ?", "#{Time.current.year}.#{format('%02d', Time.current.month)}%")
                           .maximum(:numero)
    
    sequencial = if ultimo_numero
                  ultimo_numero.split('.').last.to_i + 1
                else
                  1
                end

    self.numero = format("%04d.%02d.%06d", 
                        Time.current.year,
                        Time.current.month,
                        sequencial)
  end
end
