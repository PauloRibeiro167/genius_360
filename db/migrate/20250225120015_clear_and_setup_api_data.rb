class ClearAndSetupApiData < ActiveRecord::Migration[6.1]
  def up
    # Remove tabela existente se houver
    drop_table :api_data if table_exists?(:api_data)

    # Cria a tabela com a estrutura correta
    create_table :api_data do |t|
      t.string :source, null: false
      t.json :data, null: false
      t.datetime :collected_at, null: false
      t.timestamps
    end

    add_index :api_data, :collected_at
    add_index :api_data, :source
  end

  def down
    drop_table :api_data if table_exists?(:api_data)
  end
end
