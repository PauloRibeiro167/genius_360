class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :nome
      t.string :email
      t.string :telefone
      t.text :observacoes
      t.string :status

      t.timestamps
    end
  end
end
