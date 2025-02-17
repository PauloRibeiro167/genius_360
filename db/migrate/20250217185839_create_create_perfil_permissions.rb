class CreateCreatePerfilPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :create_perfil_permissions do |t|
      t.references :perfil, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
