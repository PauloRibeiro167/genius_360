class Consulta::ServidorFederal < ApplicationRecord
  include Discard::Model
  
  # Escopo padrão para mostrar apenas registros ativos
  default_scope -> { kept }

  # Definição dos atributos pesquisáveis
  def self.ransackable_attributes(auth_object = nil)
    %w[id cpf nome cargo orgao salario situacao tipo_servidor codigo_matricula_formatado flag_afastado orgao_lotacao_codigo orgao_lotacao_nome orgao_lotacao_sigla orgao_exercicio_codigo orgao_exercicio_nome orgao_exercicio_sigla estado_exercicio_sigla estado_exercicio_nome codigo_funcao_cargo descricao_funcao_cargo cpf_instituidor_pensao nome_instituidor_pensao cpf_representante_pensao nome_representante_pensao remuneracao_bruta remuneracao_apos_deducoes created_at updated_at discarded_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
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
