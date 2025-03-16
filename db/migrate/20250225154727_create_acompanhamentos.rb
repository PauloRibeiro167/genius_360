class CreateAcompanhamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :acompanhamentos do |t|
      t.references :lead, null: false, foreign_key: true
      t.datetime   :data_acompanhamento
      t.text       :resultado
      t.string     :tipo_acompanhamento
      t.references :usuario, foreign_key: true
      t.string     :status
      t.datetime   :proxima_data
      t.integer    :prioridade
      t.integer    :duracao_minutos

      t.timestamps
    end
    
    add_index :acompanhamentos, :data_acompanhamento
    add_index :acompanhamentos, :status
  end
end
