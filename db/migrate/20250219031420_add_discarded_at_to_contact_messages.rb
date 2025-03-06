class AddDiscardedAtToContactMessages < ActiveRecord::Migration[7.0]
  def up
    # Não faz nada se a coluna já existir
    return if column_exists?(:contact_messages, :discarded_at)
    
    add_column :contact_messages, :discarded_at, :datetime
    add_index :contact_messages, :discarded_at
  end

  def down
    remove_column :contact_messages, :discarded_at if column_exists?(:contact_messages, :discarded_at)
  end
end
