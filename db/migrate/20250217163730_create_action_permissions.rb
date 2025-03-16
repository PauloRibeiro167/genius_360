class CreateActionPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :action_permissions do |t|
      t.string :name
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
