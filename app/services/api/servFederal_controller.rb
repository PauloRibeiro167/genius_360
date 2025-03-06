require "net/http"
require "json"
require "fileutils"
require "date"

class ServFederalController
  previous_month = Date.today.prev_month
  MES = previous_month.strftime("%m")
  ANO = previous_month.strftime("%Y")

  API_KEY = "f815d9928ae9a6509cd96704fd021028"
  CPF = "07362196334"

  def fetch_data(page)
    url = URI("https://api.portaldatransparencia.gov.br/api-de-dados/servidores?cpf=#{CPF}&pagina=#{page}")
    puts "Fetching URL: #{url}"
    request = Net::HTTP::Get.new(url)
    request["chave-api-dados"] = API_KEY
    request["accept"] = "*/*"
    puts "Using API Key: #{API_KEY}"
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"
    return nil if response.code == "404"
    data = JSON.parse(response.body)
    return nil if data.nil? || data.empty?
    data
  rescue StandardError => e
    puts "Erro ao buscar dados: #{e.message}"
    nil
  end

  def save_test_cpfs(cpf)
    cpfs = []
    file_path = "/home/paulo/Documentos/projetos_de_teste/fetch_PDTCE/cfs/cpfs_testados.json"
    if File.exist?(file_path)
      file = File.read(file_path)
      cpfs = JSON.parse(file)
    end
    cpfs << cpf
    File.open(file_path, "w") do |file|
      file.write(JSON.pretty_generate(cpfs))
    end
  end

  def save_not_found_cpfs(cpf)
    cpfs = []
    file_path = "/home/paulo/Documentos/projetos_de_teste/fetch_PDTCE/cfs/cpfs_not_found.json"
    if File.exist?(file_path)
      file = File.read(file_path)
      cpfs = JSON.parse(file)
    end
    cpfs << cpf
    File.open(file_path, "w") do |file|
      file.write(JSON.pretty_generate(cpfs))
    end
  end

  def run
    dir_name = "/workspaces/sispred/app/services/database"
    FileUtils.mkdir_p(dir_name)

    save_test_cpfs(CPF)

    page = 1
    all_data = []

    loop do
      data = fetch_data(page)
      if data.nil?
        save_not_found_cpfs(CPF)
        break
      end

      ids_count = data.size
      break if ids_count == 0

      all_data.concat(data)

      puts "Número de IDs retornados na página #{page}: #{ids_count}"

      page += 1
    end

    if all_data.empty?
      puts "Nenhum dado foi retornado pela API."
    else
      File.open("#{dir_name}/SFEDERAL.json", "w") do |file|
        file.write(JSON.pretty_generate(all_data))
      end
      puts "Todos os dados foram armazenados em #{dir_name}/SFEDERAL.json"
    end
  end
end
