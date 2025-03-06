require "net/http"
require "json"
require "fileutils"
require "date"

class ServFederalController
  API_KEY = "f815d9928ae9a6509cd96704fd021028"
  CPF = "07362196334"
  DIR_NAME = "servidores_dados"
  TESTED_CPFS_PATH = "/home/paulo/Documentos/projetos_de_teste/fetch_PDTCE/cfs/cpfs_testados.json"
  NOT_FOUND_CPFS_PATH = "/home/paulo/Documentos/projetos_de_teste/fetch_PDTCE/cfs/cpfs_not_found.json"
  OUTPUT_PATH = "/home/paulo/Documentos/projetos_de_teste/fetch_PDTCE/servidores_dados/SFEDERAL.json"

  attr_reader :all_data

  def initialize
    previous_month = Date.today.prev_month
    @mes = previous_month.strftime("%m")
    @ano = previous_month.strftime("%Y")
  end

  def run
    FileUtils.mkdir_p(DIR_NAME)
    save_test_cpfs(CPF)
    fetch_and_save_data
  end

  private

  def fetch_data(page)
    url = URI("https://api.portaldatransparencia.gov.br/api-de-dados/servidores?cpf=#{CPF}&pagina=#{page}")
    request = Net::HTTP::Get.new(url)
    request["chave-api-dados"] = API_KEY
    request["accept"] = "*/*"
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    return nil if response.code == "404"
    data = JSON.parse(response.body)
    return nil if data.nil? || data.empty?
    data
  rescue StandardError => e
    puts "Erro ao buscar dados: #{e.message}"
    nil
  end

  def save_test_cpfs(cpf)
    cpfs = load_json(TESTED_CPFS_PATH)
    cpfs << cpf
    save_json(TESTED_CPFS_PATH, cpfs)
  end

  def save_not_found_cpfs(cpf)
    cpfs = load_json(NOT_FOUND_CPFS_PATH)
    cpfs << cpf
    save_json(NOT_FOUND_CPFS_PATH, cpfs)
  end

  def load_json(file_path)
    return [] unless File.exist?(file_path)
    file = File.read(file_path)
    JSON.parse(file)
  end

  def save_json(file_path, data)
    File.open(file_path, "w") do |file|
      file.write(JSON.pretty_generate(data))
    end
  end

  def fetch_and_save_data
    page = 1
    @all_data = []

    loop do
      data = fetch_data(page)
      if data.nil?
        save_not_found_cpfs(CPF)
        break
      end

      ids_count = data.size
      break if ids_count == 0

      @all_data.concat(data)
      page += 1
    end

    if @all_data.empty?
      puts "Nenhum dado foi retornado pela API."
    else
      File.open(OUTPUT_PATH, "w") do |file|
        file.write(JSON.pretty_generate(@all_data))
      end
      puts "Todos os dados foram armazenados em #{OUTPUT_PATH}"
    end
  end
end
