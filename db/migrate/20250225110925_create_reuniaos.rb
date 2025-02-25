class CreateReuniaos < ActiveRecord::Migration[8.0]
  def change
    create_table :reuniaos do |t|
      t.string :titulo
      t.text :descricao
      t.datetime :data
      t.string :local
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
