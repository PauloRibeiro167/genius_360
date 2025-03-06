class CreateProposta < ActiveRecord::Migration[8.0]
  def change
    create_table :proposta do |t|
      t.string :numero
      t.string :status

      t.timestamps
    end
  end
end
