class CreatePerfilPermission < ApplicationRecord
  include Discard::Model

  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id created_at updated_at discarded_at perfil_id permission_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[perfil permission]
  end

  # Define os aliases para busca
  ransacker :perfil_name do
    Arel.sql("perfils.name")
  end

  ransacker :permission_name do
    Arel.sql("permissions.name")
  end

  belongs_to :perfil, required: true
  belongs_to :permission, required: true

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
