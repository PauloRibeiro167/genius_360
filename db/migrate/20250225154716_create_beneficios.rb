class CreateBeneficios < ActiveRecord::Migration[8.0]
  def change
    create_table :beneficios do |t|
      t.string :nome
      t.text :descricao
      t.datetime :descartado_em

      t.timestamps
    end
  end
end
