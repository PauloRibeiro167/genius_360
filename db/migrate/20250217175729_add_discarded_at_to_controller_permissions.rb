class AddDiscardedAtToControllerPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :controller_permissions, :discarded_at, :datetime
    add_index :controller_permissions, :discarded_at
  end
end
