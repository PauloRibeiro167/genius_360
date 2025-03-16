class CreateControllerPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :controller_permissions do |t|
      t.string :controller_name, null: false
      t.string :action_name, null: false
      t.string :description
      t.boolean :active, default: true
      t.references :permissions, null: true, foreign_key: true
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
