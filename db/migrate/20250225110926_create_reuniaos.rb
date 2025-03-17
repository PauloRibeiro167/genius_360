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
  end
end
