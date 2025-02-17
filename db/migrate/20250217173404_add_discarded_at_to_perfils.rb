class AddDiscardedAtToPerfils < ActiveRecord::Migration[8.0]
  def change
    add_column :perfils, :discarded_at, :datetime
    add_index :perfils, :discarded_at
  end
end
