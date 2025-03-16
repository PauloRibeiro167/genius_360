class CreateTaxasConsignados < ActiveRecord::Migration[8.0]
  def change
    create_table :taxas_consignados do |t|
      t.string :nome, null: false  # Nome/descrição da taxa
      t.decimal :taxa_minima, precision: 6, scale: 3  # Taxa mínima em % (mensal)
      t.decimal :taxa_maxima, precision: 6, scale: 3  # Taxa máxima em % (mensal)
      t.integer :prazo_minimo, default: 1  # Prazo mínimo em meses
      t.integer :prazo_maximo  # Prazo máximo em meses
      t.decimal :margem_emprestimo, precision: 5, scale: 2  # % da margem para empréstimo
      t.decimal :margem_cartao, precision: 5, scale: 2  # % da margem para cartão
      t.string :tipo_operacao  # Empréstimo, Cartão, Refinanciamento, Portabilidade, etc.
      t.date :data_vigencia_inicio  # Quando a taxa começou a valer
      t.date :data_vigencia_fim  # Quando a taxa expira (null = sem expiração)
      t.boolean :ativo, default: true
      t.datetime :discarded_at  # Para soft delete
      
      t.timestamps
    end
    
    add_index :taxas_consignados, :nome
    add_index :taxas_consignados, :ativo
    add_index :taxas_consignados, :tipo_operacao
    add_index :taxas_consignados, :data_vigencia_inicio
    add_index :taxas_consignados, :data_vigencia_fim
    add_index :taxas_consignados, :discarded_at
  end
end