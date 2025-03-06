class AddDiscardedAtToActionPermissions < ActiveRecord::Migration[8.0]
  def change
    add_column :action_permissions, :discarded_at, :datetime
    add_index :action_permissions, :discarded_at
  end
end
