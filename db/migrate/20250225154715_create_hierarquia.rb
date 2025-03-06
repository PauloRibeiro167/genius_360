class CreateHierarquia < ActiveRecord::Migration[8.0]
  def change
    create_table :hierarquia do |t|
      t.string :nome
      t.integer :nivel

      t.timestamps
    end
  end
end
