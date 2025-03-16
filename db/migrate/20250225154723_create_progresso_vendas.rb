class CreateProgressoVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :progresso_vendas do |t|
      t.references :user, null: false, foreign_key: true
      t.date    :data
      t.decimal :valor_vendas, precision: 10, scale: 2
      t.integer :quantidade_vendas, default: 0
      t.decimal :meta_valor, precision: 10, scale: 2
      t.integer :meta_quantidade
      t.decimal :percentual_comissao, precision: 5, scale: 2
      t.decimal :valor_comissao, precision: 10, scale: 2
      t.string  :status, default: 'pendente' # pendente, aprovado, pago
      t.references :equipe, foreign_key: true
      t.string  :canal_venda
      t.string  :regiao
      t.decimal :ticket_medio, precision: 10, scale: 2
      t.decimal :taxa_conversao, precision: 5, scale: 2
      t.text    :observacoes

      t.timestamps
    end
    
    add_index :progresso_vendas, :data
    add_index :progresso_vendas, :status
  end
end
