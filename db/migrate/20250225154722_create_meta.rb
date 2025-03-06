class CreateMeta < ActiveRecord::Migration[8.0]
  def change
    create_table :meta do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :tipo_meta
      t.decimal :valor_meta
      t.date :data_inicio
      t.date :data_fim
      t.string :status

      t.timestamps
    end
  end
end
