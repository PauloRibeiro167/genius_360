class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :email
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :cpf_encrypted
      t.datetime :discarded_at
      t.string :tipo
      t.references :perfil, null: false, foreign_key: true
      t.references :hierarquia, null: false, foreign_key: true

      t.timestamps
    end
    add_index :usuarios, :email, unique: true
  end
end
