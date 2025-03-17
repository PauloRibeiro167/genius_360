class CreateParticipantes < ActiveRecord::Migration[8.0]
  def change
    create_table :participantes do |t|
      t.references :reuniao, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'pendente' # pendente, confirmado, recusado
      t.text :observacoes
      
      t.timestamps
      
      t.index [:reuniao_id, :user_id], unique: true
    end
  end
end