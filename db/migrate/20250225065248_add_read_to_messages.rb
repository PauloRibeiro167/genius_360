class AddReadToMessages < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:messages, :read)
      add_column :messages, :read, :boolean, default: false
      add_index :messages, :read
    end
  end
end
