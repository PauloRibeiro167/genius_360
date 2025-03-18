class Beneficio < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Validações
  validates :nome, presence: true, uniqueness: true
  validates :codigo, presence: true, 
                    uniqueness: true, 
                    numericality: { only_integer: true, greater_than: 0 }
  validates :categoria, presence: true
  validates :margem_padrao, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :margem_cartao_padrao, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # Scopes
  scope :ativos, -> { where(ativo: true) }
  scope :por_categoria, ->(categoria) { where(categoria: categoria) }
  scope :consignaveis, -> { where(consignavel: true) }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id nome descricao codigo categoria consignavel ativo discarded_at created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  before_discard do
    # Adicione ações a serem executadas antes de descartar
  end

  after_discard do
    # Adicione ações a serem executadas após descartar
  end

  before_undiscard do
    # Adicione ações a serem executadas antes de restaurar
  end

  after_undiscard do
    # Adicione ações a serem executadas após restaurar
  end
end
