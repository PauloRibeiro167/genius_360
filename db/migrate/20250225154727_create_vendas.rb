class CreateVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :vendas do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :cliente, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal    :valor_venda
      t.datetime   :data_venda
      t.datetime   :data_contratacao
      t.boolean    :indicacao, default: false
      t.references :parceiro, null: true, foreign_key: true # Alterado para null: true
      t.datetime   :discarded_at

      t.timestamps
    end
  end
end
