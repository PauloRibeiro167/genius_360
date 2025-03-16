class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.boolean :read, default: false
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :messages, :read
    add_index :messages, :discarded_at
  end
end
