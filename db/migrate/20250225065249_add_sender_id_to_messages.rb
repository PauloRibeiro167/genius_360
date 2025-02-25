class AddSenderIdToMessages < ActiveRecord::Migration[8.0]
  def up
    # Adiciona a nova coluna
    add_column :messages, :sender_id, :integer
    
    # Se existir a coluna user_id, copie os dados
    if column_exists?(:messages, :user_id)
      execute("UPDATE messages SET sender_id = user_id")
      remove_column :messages, :user_id
    end
    
    # Adiciona o índice
    add_index :messages, :sender_id
  end

  def down
    remove_column :messages, :sender_id
  end
end
