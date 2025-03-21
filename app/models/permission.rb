class Permission < ApplicationRecord
  include Discard::Model

  # Mantendo apenas as associações que já funcionam
  has_many :perfil_permissions
  has_many :perfis, through: :perfil_permissions
  has_many :controller_permissions
  has_many :controller_permission_actions, through: :controller_permissions
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["controller_permissions", "perfil_permissions", "perfis", "controller_permission_actions"]
  end

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
