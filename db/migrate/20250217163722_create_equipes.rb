class CreateEquipes < ActiveRecord::Migration[8.0]
  def change
    create_table :equipes do |t|
      t.string :nome, null: false
      t.text :descricao
      t.references :lider, foreign_key: { to_table: :users }  # Usuário líder da equipe
      t.string :tipo_equipe  # Ex: Vendas, Atendimento, Administração
      t.string :regiao_atuacao
      t.boolean :ativo, default: true
      t.datetime :discarded_at  # Para soft delete

      t.timestamps
    end
    
    add_index :equipes, :nome, unique: true
    add_index :equipes, :tipo_equipe
    add_index :equipes, :regiao_atuacao
    add_index :equipes, :ativo
    add_index :equipes, :discarded_at
  end
end