require "csv"

module Csv
  class DynamicCsvImportService
    def initialize(file_path)
      @file_path = file_path
    end

    def call
      CSV.foreach(@file_path, headers: true) do |row|
        attributes = {}
        row.each do |header, value|
          field_config = find_field_configuration(header)

          if field_config
            table_name = field_config[:table_name]
            column_name = field_config[:column_name]

            attributes[table_name] ||= {}
            attributes[table_name][column_name] = value
          end
        end

        create_or_update_records(attributes)
      end
    end

    private

    attr_reader :file_path

    def find_field_configuration(header)
      case header
      when "Nome do Lead"
        { table_name: :leads, column_name: :nome }
      when "Email do Lead"
        { table_name: :leads, column_name: :email }
      else
        nil
      end
    end

    def create_or_update_records(attributes)
      attributes.each do |table_name, column_attributes|
        case table_name
        when :leads
          Lead.create(column_attributes)
        end
      end
    end
  end
end
