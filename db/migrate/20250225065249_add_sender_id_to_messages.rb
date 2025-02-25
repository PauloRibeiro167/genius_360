class AddSenderIdToMessages < ActiveRecord::Migration[8.0]
  def up
    # Verifica se a coluna sender_id não existe antes de adicioná-la
    unless column_exists?(:messages, :sender_id)
      add_column :messages, :sender_id, :integer
      add_index :messages, :sender_id
    end
    
    # Se existir a coluna user_id, copie os dados para sender_id
    if column_exists?(:messages, :user_id)
      execute("UPDATE messages SET sender_id = user_id")
      remove_column :messages, :user_id
    end
  end

  def down
    # Reverte as alterações
    if column_exists?(:messages, :sender_id)
      remove_column :messages, :sender_id
    end
  end
end
