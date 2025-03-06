class CreateAcompanhamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :acompanhamentos do |t|
      t.references :lead, null: false, foreign_key: true
      t.datetime :data_acompanhamento
      t.text :resultado

      t.timestamps
    end
  end
end
