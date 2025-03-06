require "net/http"
require "json"
require "fileutils"

class ServCeController
  def run
    fetch_and_store_data
  end

  private

  def fetch_data(page)
    url = URI("https://api-dados-abertos.cearatransparente.ce.gov.br/transparencia/servidores/salarios?year=2024&month=12&page=#{page}")
    response = Net::HTTP.get_response(url)
    return nil if response.code == "404"
    JSON.parse(response.body)
  end

  def fetch_and_store_data
    dir_name = "servidores_dados"
    FileUtils.mkdir_p(dir_name)

    page = 1
    all_data = []

    loop do
      data = fetch_data(page)
      break if data.nil?

      ids_count = data["data"].size
      break if ids_count == 0

      all_data.concat(data["data"])

      puts "Número de IDs retornados na página #{page}: #{ids_count}"

      page += 1
    end

    File.open("#{dir_name}/SPDCE.json", "w") do |file|
      file.write(JSON.pretty_generate(all_data))
    end

    puts "Todos os dados foram armazenados em #{dir_name}/SPDCE.json"
  end
end
