class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :value, precision: 10, scale: 2, default: 0
      t.references :user, foreign_key: true
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
