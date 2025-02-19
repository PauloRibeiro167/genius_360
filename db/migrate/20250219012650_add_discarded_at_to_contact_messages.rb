class AddDiscardedAtToContactMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :contact_messages, :discarded_at, :datetime
  end
end
