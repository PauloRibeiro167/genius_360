class AddDiscardedAtToPerfilPermissions < ActiveRecord::Migration[8.0]
  def change
    add_column :perfil_permissions, :discarded_at, :datetime
    add_index :perfil_permissions, :discarded_at
  end
end
