class CreateReuniaos < ActiveRecord::Migration[8.0]
  def change
    create_table :reuniaos do |t|
      t.string :titulo
      t.text :descricao
      t.datetime :data_inicio
      t.datetime :data_fim
      t.string :local_fisico
      t.string :sala
      t.string :link_reuniao
      t.string :plataforma_virtual
      t.string :status, default: 'agendada' # agendada, confirmada, cancelada, finalizada
      t.references :organizador, null: false, foreign_key: { to_table: :users }
      t.string :memorando_pdf # Caminho para o arquivo PDF do memorando
      t.datetime :discarded_at

      t.timestamps
    end
    
    create_table :participantes do |t|
      t.references :reuniao, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'pendente' # pendente, confirmado, recusado
      t.text :observacoes
      
      t.timestamps
      
      t.index [:reuniao_id, :user_id], unique: true
    end
    
    # Migration auxiliar para agenda dos usuários (se não existir ainda)
    create_table :disponibilidades do |t|
      t.references :user, null: false, foreign_key: true
      t.string :dia_semana
      t.time :hora_inicio
      t.time :hora_fim
      t.boolean :disponivel, default: true
      
      t.timestamps
    end
  end
end
