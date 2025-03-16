class CreateParceiros < ActiveRecord::Migration[8.0]
  def change
    create_table :parceiros do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :percentual_comissao, precision: 5, scale: 2, default: 0
      t.string :chave_pix
      t.string :banco
      t.string :agencia
      t.string :conta
      t.string :tipo_conta, default: 'corrente'
      t.string :titular_conta
      t.string :cpf_titular
      t.string :email_titular
      t.string :telefone_titular
      t.string :endereco_titular
      t.string :cidade_titular
      t.string :estado_titular
      t.string :cep_titular
      t.datetime :discarded_at
      t.string :periodicidade_pagamento, default: 'mensal'
      t.integer :dia_pagamento, default: 5
      t.decimal :valor_minimo_pagamento, precision: 10, scale: 2, default: 0
      t.string :codigo_parceiro, null: false
      t.string :qrcode_path
      t.string :url_indicacao
      t.boolean :ativo, default: true
      t.integer :nivel_parceiro, default: 1
      t.text :observacoes
      t.integer :total_indicacoes, default: 0
      t.integer :indicacoes_convertidas, default: 0
      t.decimal :valor_total_comissoes, precision: 10, scale: 2, default: 0
      t.datetime :data_aprovacao
      t.datetime :proximo_pagamento
      t.datetime :ultimo_pagamento

      t.timestamps
    end
    
    add_index :parceiros, :codigo_parceiro, unique: true
    add_index :parceiros, :discarded_at
    add_index :parceiros, :ativo
    add_index :parceiros, :proximo_pagamento 
  end
end
