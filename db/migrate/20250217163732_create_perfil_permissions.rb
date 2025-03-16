class CreatePerfilPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :perfil_permissions do |t|
      t.references :perfil, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :perfil_permissions, [ :perfil_id, :permission_id ], unique: true
  end
end
