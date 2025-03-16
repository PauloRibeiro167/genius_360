class CreateAcessos < ActiveRecord::Migration[8.0]
  def change
    create_table :acessos do |t|
      t.references :user, null: true, foreign_key: true
      t.string :descricao
      t.datetime :data_acesso
      t.string :ip
      t.string :modelo_dispositivo

      t.timestamps
    end
  end
end
