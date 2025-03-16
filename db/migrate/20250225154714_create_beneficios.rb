class CreateBeneficios < ActiveRecord::Migration[8.0]
  def change
    create_table :beneficios do |t|
      t.string :nome, null: false
      t.text :descricao
      t.string :categoria, null: false  # Para agrupar por categoria (INSS, Servidores, etc)
      t.boolean :consignavel, default: true  # Indica se o benefício permite consignado
      t.decimal :margem_padrao, precision: 5, scale: 2  # Margem padrão regulamentada
      t.decimal :margem_cartao_padrao, precision: 5, scale: 2  # Margem padrão para cartão
      t.string :fonte_pagadora  # INSS, Gov. Federal, Gov. Estadual, etc.
      t.boolean :ativo, default: true  # Indica se o benefício está ativo para seleção
      t.datetime :discarded_at  # Para soft delete
      
      t.timestamps
    end
    
    # Índices para melhorar a performance
    add_index :beneficios, :nome
    add_index :beneficios, :categoria
    add_index :beneficios, :fonte_pagadora
    add_index :beneficios, :consignavel
    add_index :beneficios, :ativo
    add_index :beneficios, :discarded_at
  end
end
