class CreateFinancialTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_transactions do |t|
      t.string :tipo, null: false, default: "entrada"
      t.decimal :valor, precision: 15, scale: 2, null: false
      t.string :descricao
      t.string :categoria
      
      t.date :data_competencia, null: false
      t.date :data_vencimento
      t.date :data_pagamento
      
      t.string :forma_pagamento
      t.string :status, default: "pendente"
      
      t.string :numero_documento
      t.string :documento_path
      
      t.references :user, foreign_key: true, null: false
      t.references :aprovado_por, foreign_key: { to_table: :users }
      t.references :entidade, polymorphic: true
      t.string :conta_bancaria  # Alterado de references para string
      
      t.string :centro_custo
      t.text :observacoes
      t.datetime :discarded_at
      t.string :numero_parcela
      t.references :transacao_relacionada
      
      t.boolean :reembolsavel, default: false
      t.references :solicitante_id, foreign_key: { to_table: :users }
      t.string :status_reembolso
      t.date :data_solicitacao_reembolso
      t.text :justificativa_reembolso
      t.string :comprovante_reembolso_path

      t.timestamps
    end
    
    add_index :financial_transactions, :tipo
    add_index :financial_transactions, :data_competencia
    add_index :financial_transactions, :data_vencimento
    add_index :financial_transactions, :status
    add_index :financial_transactions, :discarded_at
    add_index :financial_transactions, :categoria
    add_index :financial_transactions, :conta_bancaria  # Adicionado índice para conta_bancaria
    
    add_index :financial_transactions, :reembolsavel
    add_index :financial_transactions, :status_reembolso
    add_index :financial_transactions, :data_solicitacao_reembolso
  end
end
