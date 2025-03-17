class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :type
      t.references :user, null: false, foreign_key: true
      t.json :data
      t.datetime :read_at
      t.string :url
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
