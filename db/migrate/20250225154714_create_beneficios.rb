class CreateBeneficios < ActiveRecord::Migration[8.0]
  def change
    create_table :beneficios do |t|
      t.string  :nome, null: false
      t.text    :descricao
      t.string  :categoria, null: false
      t.integer :codigo, null: false
      t.boolean :consignavel, default: true, null: false
      t.decimal :margem_padrao, precision: 5, scale: 2
      t.decimal :margem_cartao_padrao, precision: 5, scale: 2
      t.boolean :ativo, default: true, null: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :beneficios, :nome, unique: true
    add_index :beneficios, :codigo, unique: true
    add_index :beneficios, :categoria
    add_index :beneficios, :consignavel
    add_index :beneficios, :ativo
    add_index :beneficios, :discarded_at
  end
end
