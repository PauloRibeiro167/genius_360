class CreateEquipeUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :equipes_users do |t|
      # Modificar estas linhas para não criar índices únicos implícitos
      t.references :equipe, null: false, foreign_key: true, index: false
      t.references :user, null: false, foreign_key: true, index: false
      t.string :cargo
      t.date :data_entrada
      t.date :data_saida
      t.boolean :ativo, default: true
      t.decimal :meta_individual, precision: 10, scale: 2
      t.datetime :discarded_at

      t.timestamps
    end
    
    # Adicionar índices compostos que permitam múltiplas entradas
    add_index :equipes_users, [:equipe_id, :user_id, :cargo, :data_entrada], 
              name: 'idx_equipes_users_unique_active', 
              unique: true,
              where: "ativo = true"
              
    add_index :equipes_users, :equipe_id
    add_index :equipes_users, :user_id
    add_index :equipes_users, :cargo
    add_index :equipes_users, :ativo
    add_index :equipes_users, :discarded_at
  end
end