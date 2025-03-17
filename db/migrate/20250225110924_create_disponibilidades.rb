class CreateDisponibilidades < ActiveRecord::Migration[8.0]
  def change
    create_table :disponibilidades do |t|
      t.references :user, null: false, foreign_key: true
      t.string :dia_semana, null: false
      t.time :hora_inicio, null: false
      t.time :hora_fim, null: false
      t.boolean :disponivel, default: true, null: false
      
      t.timestamps
    end
  end
end