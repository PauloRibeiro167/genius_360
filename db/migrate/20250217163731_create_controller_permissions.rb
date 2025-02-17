class CreateControllerPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :controller_permissions do |t|
      t.string :name

      t.timestamps
    end
  end
end
