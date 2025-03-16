class CreateTaxasBeneficios < ActiveRecord::Migration[8.0]
  def change
    create_table :taxas_beneficios do |t|
      t.references :taxa_consignado, null: false, foreign_key: { to_table: :taxas_consignados }
      t.references :beneficio, null: false, foreign_key: true
      t.boolean :aplicavel, default: true
      t.text :regras_especiais
      t.boolean :ativo, default: true
      t.datetime :discarded_at
      
      t.timestamps
    end
    
    add_index :taxas_beneficios, [:taxa_consignado_id, :beneficio_id], unique: true
    add_index :taxas_beneficios, :ativo
    add_index :taxas_beneficios, :discarded_at
  end
end