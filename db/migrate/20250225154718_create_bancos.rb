class CreateBancos < ActiveRecord::Migration[8.0]
  def change
    create_table :bancos do |t|
      t.string :numero_identificador
      t.string :nome
      t.text :descricao
      t.text :regras_gerais
      t.datetime :descartado_em

      t.timestamps
    end
  end
end
