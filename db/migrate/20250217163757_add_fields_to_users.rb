class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :cpf, :string
    add_index :users, :cpf, unique: true
    add_column :users, :last_known_ip, :string
    add_column :users, :location, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_reference :users, :perfil, null: false, foreign_key: true
  end
end
