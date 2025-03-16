class CreateHierarquias < ActiveRecord::Migration[8.0]
  def change
    create_table :hierarquias do |t|
      t.string :nome
      t.integer :nivel
      t.text :descricao
      t.boolean :ativo, default: true
      t.datetime :discarded_at

      t.timestamps
    end
    
    add_index :hierarquias, :nivel
    add_index :hierarquias, :discarded_at
  end
end
