class CreateClientes < ActiveRecord::Migration[8.0]
  def change
    create_table :clientes do |t|
      t.string :nome
      t.string :cpf
      t.string :email
      t.string :telefone
      t.string :endereco
      t.string :cidade
      t.string :estado
      t.string :cep
      t.text :observacoes
      t.datetime :discarded_at
      t.boolean :ativo

      t.timestamps
    end
    add_index :clientes, :nome
    add_index :clientes, :cpf, unique: true
    add_index :clientes, :email
  end
end
