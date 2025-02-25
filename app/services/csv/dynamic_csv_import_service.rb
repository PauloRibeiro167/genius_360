require 'csv'

class DynamicCsvImportService
  def initialize(file)
    @file = file
  end

  def import
    CSV.foreach(@file.path, headers: true) do |row|
      attributes = {}
      row.each do |header, value|
        # Lógica para determinar a qual tabela e coluna o 'header' pertence
        # Isso pode envolver a leitura de um arquivo de configuração ou o uso de convenções de nomenclatura
        # Exemplo:
        field_config = find_field_configuration(header)

        if field_config
          table_name = field_config[:table_name]
          column_name = field_config[:column_name]

          # Atribui o valor ao hash de atributos, usando a tabela e coluna corretas
          attributes[table_name] ||= {}
          attributes[table_name][column_name] = value
        end
      end

      # Agora você tem um hash 'attributes' que contém os dados organizados por tabela
      # Exemplo:
      # attributes = {
      #   leads: { nome: '...', email: '...' },
      #   enderecos: { rua: '...', cidade: '...' }
      # }

      # Lógica para criar ou atualizar registros no banco de dados
      create_or_update_records(attributes)
    end
  end

  private

  def find_field_configuration(header)
    # Lógica para encontrar a configuração do campo com base no 'header'
    # Isso pode envolver a leitura de um arquivo de configuração (YAML, JSON, etc.)
    # ou o uso de convenções de nomenclatura
    # Exemplo:
    # dynamic_fields = YAML.load_file('config/dynamic_fields.yml')
    # dynamic_fields[header]

    # Substitua este exemplo com sua lógica real
    case header
    when 'Nome do Lead'
      { table_name: :leads, column_name: :nome }
    when 'Email do Lead'
      { table_name: :leads, column_name: :email }
    # Adicione mais casos conforme necessário
    else
      nil
    end
  end

  def create_or_update_records(attributes)
    # Lógica para criar ou atualizar registros no banco de dados
    # Itere sobre o hash 'attributes' e crie/atualize os registros nas tabelas correspondentes
    # Exemplo:
    # lead_attributes = attributes[:leads]
    # Lead.create_or_update_by(email: lead_attributes[:email], lead_attributes)

    # endereco_attributes = attributes[:enderecos]
    # Endereco.create_or_update_by(lead_id: lead.id, endereco_attributes)

    # Adapte este exemplo com sua lógica real
    attributes.each do |table_name, column_attributes|
      case table_name
      when :leads
        Lead.create(column_attributes)
      #when :enderecos
      #  Endereco.create(column_attributes)
      # Adicione mais casos conforme necessário
      end
    end
  end
end
