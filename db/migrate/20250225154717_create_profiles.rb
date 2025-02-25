class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.jsonb :permissions
      t.datetime :descartado_em

      t.timestamps
    end
  end
end
