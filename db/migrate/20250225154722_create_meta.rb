class CreateMeta < ActiveRecord::Migration[8.0]
  def change
    create_table :meta do |t|
      t.references :user_id, null: false, foreign_key: true
      t.string :tipo_meta
      t.decimal :valor_meta
      t.date :data_inicio
      t.date :data_fim
      t.string :status, default: 'em andamento'
      t.text :observacoes
      t.datetime :discarded_at
      t.timestamp :modified_at, precision: 6

      t.timestamps
    end
  end
end
