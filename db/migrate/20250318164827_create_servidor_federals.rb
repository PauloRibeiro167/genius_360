class CreateServidorFederals < ActiveRecord::Migration[8.0]
  def change
    create_table :servidor_federals do |t|
      # Campos básicos do servidor
      t.string :cpf
      t.string :nome
      t.string :cargo
      t.string :orgao
      t.string :salario
      
      # Campos detalhados do servidor
      t.string :situacao
      t.string :tipo_servidor
      t.string :codigo_matricula_formatado
      t.integer :flag_afastado, default: 0
      
      # Órgão de Lotação
      t.string :orgao_lotacao_codigo
      t.string :orgao_lotacao_nome
      t.string :orgao_lotacao_sigla
      
      # Órgão de Exercício
      t.string :orgao_exercicio_codigo
      t.string :orgao_exercicio_nome
      t.string :orgao_exercicio_sigla
      t.string :estado_exercicio_sigla
      t.string :estado_exercicio_nome
      
      # Função/Cargo
      t.string :codigo_funcao_cargo
      t.string :descricao_funcao_cargo
      
      # Inativo/Pensão (se aplicável)
      t.string :cpf_instituidor_pensao
      t.string :nome_instituidor_pensao
      t.string :cpf_representante_pensao
      t.string :nome_representante_pensao
      
      # Remuneração
      t.decimal :remuneracao_bruta, precision: 15, scale: 2
      t.decimal :remuneracao_apos_deducoes, precision: 15, scale: 2
      t.decimal :valor_jetons, precision: 15, scale: 2
      t.decimal :valor_honorarios_advocaticios, precision: 15, scale: 2
      
      # Informações adicionais
      t.date :data_referencia
      t.string :mes_ano_referencia
      t.text :observacoes
      
      # Detalhamentos financeiros
      t.decimal :remuneracao_basica_bruta, precision: 15, scale: 2
      t.decimal :abate_remuneracao_basica_bruta, precision: 15, scale: 2
      t.decimal :gratificacao_natalina, precision: 15, scale: 2
      t.decimal :ferias, precision: 15, scale: 2
      t.decimal :outras_remuneracoes_eventuais, precision: 15, scale: 2
      t.decimal :imposto_retido_fonte, precision: 15, scale: 2
      t.decimal :previdencia_oficial, precision: 15, scale: 2
      t.decimal :outras_deducoes_obrigatorias, precision: 15, scale: 2
      t.decimal :pensao_militar, precision: 15, scale: 2
      t.decimal :fundo_saude, precision: 15, scale: 2
      t.decimal :taxa_ocupacao_imovel_funcional, precision: 15, scale: 2
      t.decimal :verbas_indenizatorias_civil, precision: 15, scale: 2
      t.decimal :verbas_indenizatorias_militar, precision: 15, scale: 2
      t.decimal :verbas_indenizatorias_pdv, precision: 15, scale: 2
      
      # Flags
      t.boolean :remuneracao_empresa_publica, default: false
      t.boolean :existe_valor_mes, default: true
      
      # JSON para armazenar os dados completos
      t.json :dados_brutos
      t.json :rubricas
      t.json :jetons
      t.json :honorarios_advocaticios

      t.timestamps
    end
    
    # Índices para pesquisa e performance
    add_index :servidor_federals, :cpf, unique: true
    add_index :servidor_federals, :nome
    add_index :servidor_federals, :orgao
    add_index :servidor_federals, :orgao_lotacao_codigo
    add_index :servidor_federals, :orgao_exercicio_codigo
    add_index :servidor_federals, :estado_exercicio_sigla
    add_index :servidor_federals, :data_referencia
    add_index :servidor_federals, :remuneracao_apos_deducoes
    add_index :servidor_federals, :tipo_servidor
    add_index :servidor_federals, :situacao
  end
end
