class FinancialTransaction < ApplicationRecord
  include Discard::Model
  
  # Corrigindo a definição dos enums - eles precisam de um hash como argumento
  enum :tipo, { entrada: 'entrada', saida: 'saida' }
  enum :status, { pendente: 'pendente', pago: 'pago', cancelado: 'cancelado' }
  enum :status_reembolso, { solicitado: 'solicitado', aprovado: 'aprovado', negado: 'negado' }, prefix: true, allow_nil: true
  
  # Associações
  belongs_to :user
  belongs_to :aprovado_por, class_name: 'User', optional: true
  belongs_to :entidade, polymorphic: true, optional: true
  # Corrigido: solicitante_id é uma referência direta, não um id aninhado
  belongs_to :solicitante, class_name: 'User', optional: true, foreign_key: 'solicitante_id_id'
  # Corrigido: transacao_relacionada não tem foreign_key definido na migração
  belongs_to :transacao_relacionada, class_name: 'FinancialTransaction', optional: true, foreign_key: 'transacao_relacionada_id'
  
  # Validações
  validates :tipo, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :data_competencia, presence: true
  
  # Scopes
  scope :entradas, -> { where(tipo: 'entrada') }
  scope :saidas, -> { where(tipo: 'saida') }
  scope :pendentes, -> { where(status: 'pendente') }
  scope :pagas, -> { where(status: 'pago') }
  scope :canceladas, -> { where(status: 'cancelado') }
  scope :reembolsaveis, -> { where(reembolsavel: true) }
  scope :por_periodo, ->(inicio, fim) { where(data_competencia: inicio..fim) }
  scope :por_categoria, ->(categoria) { where(categoria: categoria) }
  scope :por_conta, ->(conta) { where(conta_bancaria: conta) }
  scope :por_centro_custo, ->(centro) { where(centro_custo: centro) }
  scope :com_tag, ->(tag) { where("tags LIKE ?", "%#{tag}%") }
  
  # Métodos para manipulação de status
  def pagar!(data = Date.current)
    update(status: 'pago', data_pagamento: data)
  end
  
  def cancelar!
    update(status: 'cancelado')
  end
  
  # Métodos para reembolsos
  def solicitar_reembolso!(user_id, justificativa = nil)
    update(
      reembolsavel: true, 
      solicitante_id_id: user_id, 
      status_reembolso: 'solicitado', 
      data_solicitacao_reembolso: Date.current,
      justificativa_reembolso: justificativa
    )
  end
  
  def aprovar_reembolso!(user_id)
    update(status_reembolso: 'aprovado', aprovado_por_id: user_id)
  end
  
  def negar_reembolso!
    update(status_reembolso: 'negado')
  end

  # Métodos para manipulação de tags
  def tag_list
    tags.to_s.split(',').map(&:strip)
  end

  def tag_list=(tags_array)
    self.tags = tags_array.join(',') if tags_array
  end
  
  def add_tag(tag)
    return if tag.blank?
    current_tags = tag_list
    tag = tag.strip
    unless current_tags.include?(tag)
      current_tags << tag
      self.tags = current_tags.join(',')
    end
  end
  
  def remove_tag(tag)
    return if tag.blank?
    current_tags = tag_list
    current_tags.delete(tag.strip)
    self.tags = current_tags.join(',')
  end
  
  # Métodos para análise financeira
  def self.saldo_por_periodo(inicio, fim)
    entradas.por_periodo(inicio, fim).sum(:valor) - saidas.por_periodo(inicio, fim).sum(:valor)
  end
  
  def self.analise_por_tags(inicio, fim)
    tags_unicas = where.not(tags: [nil, '']).pluck(:tags).join(',').split(',').map(&:strip).uniq
    
    resultado = {}
    tags_unicas.each do |tag|
      transacoes = com_tag(tag).por_periodo(inicio, fim)
      resultado[tag] = {
        entradas: transacoes.entradas.sum(:valor),
        saidas: transacoes.saidas.sum(:valor),
        saldo: transacoes.entradas.sum(:valor) - transacoes.saidas.sum(:valor)
      }
    end
    resultado
  end
end
