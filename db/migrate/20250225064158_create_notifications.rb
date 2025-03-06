class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type
      t.json :data
      t.datetime :read_at
      t.string :url

      t.timestamps
    end
  end
end
