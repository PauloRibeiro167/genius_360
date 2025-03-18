class Acesso < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id descricao data_acesso ip modelo_dispositivo created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  # Corrigindo a associação para apontar para user em vez de usuario
  belongs_to :user, optional: true

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
