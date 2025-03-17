class ContactMessage < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email phone message status created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Lista de tipos de requisição - movido para ANTES da validação
  def self.request_types
    [
      'Dúvida',
      'Suporte',
      'Orçamento',
      'Parceria',
      'Outro'
    ]
  end

  # Definição correta do enum
  enum :status, {
    nova: 0,
    em_analise: 1,
    respondida: 2,
    encerrada: 3,
    pendente: 4
  }

  enum :request_type, {
    informacao: 0,
    orcamento: 1,
    suporte: 2,
    reclamacao: 3,
    sugestao: 4,
    parceria: 5,
    demonstracao: 6
  }

  # Validações - agora request_types já está definido
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :request_type, presence: true, inclusion: { in: request_types }
  
  def status_formatado
    case status
    when 'nova' then 'Nova'
    when 'em_analise' then 'Em Análise'
    when 'respondida' then 'Respondida'
    when 'encerrada' then 'Encerrada'
    when 'pendente' then 'Pendente'
    end
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
