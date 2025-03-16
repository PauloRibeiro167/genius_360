class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :nome
      t.string :email
      t.string :telefone
      t.string :status
      t.string :origem
      t.text   :observacoes
      t.jsonb  :dados_extras, default: {}

      t.timestamps
    end
  end
end
