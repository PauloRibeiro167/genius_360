class CreateAvisosUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :avisos_users do |t|
      t.references :aviso, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :avisos_users, [:aviso_id, :user_id], unique: true
  end
end
