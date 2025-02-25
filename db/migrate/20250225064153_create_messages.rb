class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
