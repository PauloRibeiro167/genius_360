class AddDiscardedAtToCreatePerfilPermissions < ActiveRecord::Migration[8.0]
  def change
    add_column :create_perfil_permissions, :discarded_at, :datetime
    add_index :create_perfil_permissions, :discarded_at
  end
end
