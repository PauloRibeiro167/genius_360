class AddDiscardedAtToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :discarded_at, :datetime
    add_index :messages, :discarded_at
  end
end
