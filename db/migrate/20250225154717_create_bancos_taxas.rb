class CreateBancosTaxas < ActiveRecord::Migration[8.0]
  def change
    create_table :bancos_taxas do |t|
      t.references :banco, null: false, foreign_key: true
      t.references :taxa_consignado, null: false, foreign_key: { to_table: :taxas_consignados }
      t.decimal :taxa_preferencial, precision: 6, scale: 3
      t.boolean :ativo, default: true
      t.datetime :discarded_at
      
      t.timestamps
    end
    
    add_index :bancos_taxas, [:banco_id, :taxa_consignado_id], unique: true
    add_index :bancos_taxas, :ativo
    add_index :bancos_taxas, :discarded_at
  end
end