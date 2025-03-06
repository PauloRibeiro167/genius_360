class EnsureApiDataStructure < ActiveRecord::Migration[6.1]
  def change
    unless table_exists?(:api_data)
      create_table :api_data do |t|
        t.string :source, null: false
        t.json :data, null: false
        t.datetime :collected_at, null: false

        t.timestamps
      end

      add_index :api_data, :collected_at
      add_index :api_data, :source
    end
  end
end
