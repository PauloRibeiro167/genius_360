require 'csv'

class Lead < ApplicationRecord
  def self.to_csv
    attributes = %w{id nome email created_at updated_at} # Adicione os atributos que você quer exportar
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |lead|
        csv << lead.attributes.values_at(*attributes)
      end
    end
  end
end
