require "net/http"
require "json"
require "fileutils"
require "date"

class ServFederalService
  API_KEY = "f815d9928ae9a6509cd96704fd021028"
  
  def fetch_data_by_cpf(cpf)
    page = 1
    all_data = []

    loop do
      data = fetch_data(cpf, page)
      break if data.nil? || data.empty?
      
      all_data.concat(data)
      page += 1
      
      # Limite de páginas para evitar loops infinitos
      break if page > 10
    end

    return all_data
  end

  def fetch_data(cpf, page = 1)
    url = URI("https://api.portaldatransparencia.gov.br/api-de-dados/servidores?cpf=#{cpf}&pagina=#{page}")
    
    request = Net::HTTP::Get.new(url)
    request["chave-api-dados"] = API_KEY
    request["accept"] = "*/*"
    
    Rails.logger.info("Consultando API de Servidores Federais: #{url}")
    
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    return nil if response.code == "404"
    
    begin
      data = JSON.parse(response.body)
      return data unless data.nil? || data.empty?
    rescue => e
      Rails.logger.error("Erro ao processar resposta da API: #{e.message}")
    end
    
    nil
  end
  
  def save_data(data)
    # Define diretório para salvar os dados
    dir_name = Rails.root.join("storage", "servidores_federais")
    FileUtils.mkdir_p(dir_name)
    
    # Gera um nome de arquivo único com timestamp
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    
    # Extrai CPF do primeiro registro se disponível
    cpf = data.first&.dig("cpf") || "desconhecido"
    
    # Salva o arquivo
    filename = "#{dir_name}/servidor_#{cpf}_#{timestamp}.json"
    File.open(filename, "w") do |file|
      file.write(JSON.pretty_generate(data))
    end
    
    Rails.logger.info("Dados do servidor salvos em: #{filename}")
    
    return filename
  end
end

# Código para teste direto
if __FILE__ == $0
  # CPF para teste
  cpf_teste = "71449159320"
  
  # Instanciar o serviço e fazer a consulta
  servico = ServFederalService.new
  puts "Consultando CPF: #{cpf_teste}..."
  
  # Executar a consulta
  resultado = servico.fetch_data_by_cpf(cpf_teste)
  
  # Exibir resultados
  if resultado && !resultado.empty?
    puts "Encontrados #{resultado.size} registros!"
    puts JSON.pretty_generate(resultado.first)
    
    # Salvar em arquivo
    arquivo = servico.save_data(resultado)
    puts "Dados salvos em: #{arquivo}"
  else
    puts "Nenhum dado encontrado para este CPF"
  end
end
