require 'csv'

class Lead < ApplicationRecord
  belongs_to :user, optional: true
  has_many :acompanhamentos, dependent: :destroy
  
  validates :nome, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :telefone, presence: true
  
  scope :ativos, -> { where(ativo: true) }
  
  def self.status_options
    ['Novo', 'Em contato', 'Qualificado', 'Proposta', 'Negociação', 'Cliente', 'Perdido']
  end
  
  def self.origem_options
    ['Site', 'Indicação', 'Redes Sociais', 'Evento', 'Email Marketing', 'Outro']
  end

  def self.to_csv
    attributes = %w{id nome email created_at updated_at} # Adicione os atributos que você quer exportar
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |lead|
        csv << lead.attributes.values_at(*attributes)
      end
    end
  end
end
