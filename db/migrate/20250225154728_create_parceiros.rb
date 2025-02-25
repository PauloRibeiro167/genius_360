class CreateParceiros < ActiveRecord::Migration[8.0]
  def change
    create_table :parceiros do |t|
      t.references :usuario, null: false, foreign_key: true
      t.decimal :percentual_comissao
      t.datetime :descartado_em

      t.timestamps
    end
  end
end
