class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  include Discard::Model

  belongs_to :perfil, optional: true

  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  def admin?
    perfil&.name == "super"
  end

  # Adicione perfil aos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id email perfil_id created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[perfil]
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
