class Token < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id user token expires_at created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  belongs_to :user, required: true

  # Callbacks para quando o registro é descartado/restaurado
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
