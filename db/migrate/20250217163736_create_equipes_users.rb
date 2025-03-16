class CreateEquipesUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :equipes_users do |t|
      t.references :equipe, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :cargo # Função do usuário na equipe
      t.date :data_entrada
      t.date :data_saida
      t.boolean :ativo, default: true
      t.decimal :meta_individual, precision: 10, scale: 2  # Meta específica para o membro na equipe
      t.datetime :discarded_at

      t.timestamps
    end
    
    # Índice composto para garantir que um usuário só apareça uma vez em cada equipe
    add_index :equipes_users, [:equipe_id, :user_id], unique: true
    add_index :equipes_users, :cargo
    add_index :equipes_users, :ativo
    add_index :equipes_users, :discarded_at
  end
end