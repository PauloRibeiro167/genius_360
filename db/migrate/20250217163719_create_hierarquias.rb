class CreateHierarquias < ActiveRecord::Migration[8.0]
  def change
    create_table :hierarquias do |t|
      t.string :nome, null: false
      t.integer :nivel, null: false
      t.text :descricao
      t.boolean :ativo, default: true, null: false
      t.datetime :discarded_at

      t.timestamps
    end
    
    add_index :hierarquias, :nivel, unique: true
    add_index :hierarquias, :nome, unique: true
    add_index :hierarquias, :discarded_at
  end
end
