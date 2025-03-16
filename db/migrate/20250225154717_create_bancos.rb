class CreateBancos < ActiveRecord::Migration[8.0]
  def change
    create_table :bancos do |t|
      t.string :numero_identificador
      t.string :nome
      t.text :descricao
      t.string :site
      t.text :regras_gerais
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
