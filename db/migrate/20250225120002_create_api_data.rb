class CreateApiData < ActiveRecord::Migration[8.0]
  def change
    create_table :api_data do |t|
      t.string :source, null: false
      t.json :data, null: false
      t.datetime :collected_at, null: false

      t.timestamps
    end

    add_index :api_data, :source
    add_index :api_data, :collected_at
  end
end
