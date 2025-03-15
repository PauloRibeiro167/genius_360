class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :name, null: false
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :permissions, :discarded_at
  end
end
