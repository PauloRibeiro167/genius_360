class CreateProgressoVendas < ActiveRecord::Migration[8.0]
  def change
    create_table :progresso_vendas do |t|
      t.references :usuario, null: false, foreign_key: true
      t.date :data
      t.decimal :valor_vendas

      t.timestamps
    end
  end
end
