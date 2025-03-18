class CreatePropostas < ActiveRecord::Migration[8.0]
  def change
    create_table :propostas do |t|
      t.string :numero
      t.string :status
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
