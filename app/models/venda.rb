class Venda < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Associações
  belongs_to :lead, required: true
  belongs_to :cliente
  belongs_to :user
  belongs_to :parceiro, optional: true  # Alterado para optional para caso não precise ser obrigatório

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id lead_id cliente_id user_id parceiro_id valor_venda data_venda data_contratacao indicacao created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[lead cliente user parceiro]
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
