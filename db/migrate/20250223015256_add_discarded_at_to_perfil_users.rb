class AddDiscardedAtToPerfilUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :perfil_users, :discarded_at, :datetime
    add_index :perfil_users, :discarded_at
  end
end
