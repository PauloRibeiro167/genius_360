require "net/http"
require "json"
require "fileutils"
require "uri"

class PbcController
  # Credenciais do cliente
  CPF = "07504094366"
  CLIENT_SECRET = "seu_client_secret"
  TOKEN_URL = "https://apigateway.conectagov.estaleiro.serpro.gov.br/oauth2/jwt-token"
  API_KEY = "f815d9928ae9a6509cd96704fd021028"

  # Função para obter o token de acesso
  def get_access_token
    uri = URI(TOKEN_URL)
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(CPF, CLIENT_SECRET)
    request.set_form_data(grant_type: "client_credentials")

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.code.to_i == 200
      JSON.parse(response.body)["access_token"]
    else
      puts "Erro ao obter token de acesso: #{response.body}"
      nil
    end
  end

  # Função para construir a URL da API com base nos parâmetros fornecidos
  def build_url(cpf, especie = nil, situacao = nil)
    base_url = "https://apigateway.conectagov.estaleiro.serpro.gov.br/api-beneficios-previdenciarios/v3/beneficios/pertence-especie-87"
    query_params = { cpf: cpf }
    query_params[:especie] = especie if especie
    query_params[:situacao] = situacao if situacao
    uri = URI(base_url)
    uri.query = URI.encode_www_form(query_params)
    uri
  end

  # Função para obter dados da API
  def fetch_data(api_key, cpf, especie = nil, situacao = nil)
    uri = build_url(cpf, especie, situacao)
    request = Net::HTTP::Get.new(uri)
    request["chave-api-dados"] = api_key
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    puts "Fetching URL: #{uri}"  # Adiciona um print para exibir a URL
    puts "Response Code: #{response.code}"  # Adiciona um print para exibir o código de resposta
    puts "Response Body: #{response.body}"  # Adiciona um print para exibir o corpo da resposta
    case response.code.to_i
    when 200
      JSON.parse(response.body)
    when 403
      puts "Erro 403: Acesso proibido. Verifique suas credenciais ou permissões."
      nil
    else
      puts "Erro inesperado: Código de resposta #{response.code}"
      nil
    end
  rescue JSON::ParserError => e
    puts "Erro ao analisar JSON: #{e.message}"
    nil
  rescue StandardError => e
    puts "Erro ao buscar dados: #{e.message}"
    nil
  end

  def run
    begin
      # Parâmetros de entrada
      cpf = "12512907520"
      especie = 87
      situacao = 2

      # Cria a pasta para armazenar os dados
      dir_name = "/workspaces/sispred/app/services/database"
      FileUtils.mkdir_p(dir_name)

      # Busca os dados da API
      data = fetch_data(API_KEY, cpf, especie, situacao)

      # Verifica se há dados para salvar
      if data.nil? || data["beneficios"].empty?
        puts "Nenhum dado foi retornado pela API."
      else
        # Armazena os resultados em um arquivo JSON
        File.open("#{dir_name}/PBC.json", "w") do |file|
          file.write(JSON.pretty_generate(data))
        end
        puts "Todos os dados foram armazenados em #{dir_name}/PBC.json"
      end
    rescue Errno::EACCES => e
      puts "Erro de permissão ao acessar o arquivo ou diretório: #{e.message}"
    rescue Errno::ENOENT => e
      puts "Erro de arquivo ou diretório não encontrado: #{e.message}"
    rescue StandardError => e
      puts "Erro inesperado: #{e.message}"
    end
  end
end
