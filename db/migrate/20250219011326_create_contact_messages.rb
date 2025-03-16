class CreateContactMessages < ActiveRecord::Migration[8.0]
  def up
    create_table :contact_messages do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :message
      t.string :request_type
      t.string :status
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :contact_messages, :discarded_at
  end

  def down
    drop_table :contact_messages if table_exists?(:contact_messages)
  end
end
