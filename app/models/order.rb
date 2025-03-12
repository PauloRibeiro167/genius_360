class Order < ApplicationRecord
  # Relacionamentos e validações aqui, se necessário
  
  # Escopo para filtrar pedidos por mês
  def self.by_month(month_name)
    month_number = Date::MONTHNAMES.index(month_name) || 
                  Date::ABBR_MONTHNAMES.index(month_name)
    
    where('extract(month from created_at) = ?', month_number) if month_number
  end
end
