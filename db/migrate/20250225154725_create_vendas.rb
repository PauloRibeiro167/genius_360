class CreateVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :vendas do |t|
      t.references :lead, null: false, foreign_key: true
      t.decimal :valor_venda
      t.datetime :data_venda
      t.datetime :data_contratacao

      t.timestamps
    end
  end
end
