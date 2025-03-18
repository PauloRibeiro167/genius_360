class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :nome, null: false
      t.string :email
      t.string :telefone
      t.string :empresa
      t.string :cargo
      t.string :origem
      t.string :status
      t.text :observacao
      t.references :user, foreign_key: true
      t.date :data_contato
      t.boolean :ativo, default: true
      t.decimal :potencial_venda, precision: 10, scale: 2
      t.string :instituicao

      t.timestamps
    end
    
    add_index :leads, :nome
    add_index :leads, :email
    add_index :leads, :status
    add_index :leads, :origem
    add_index :leads, :instituicao
  end
end
