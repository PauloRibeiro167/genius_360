class BaseController
  def save_data(source, data)
    ApiData.create!(
      source: source,
      data: data,
      collected_at: Time.current
    )
  rescue => e
    Rails.logger.error("Erro ao salvar dados de #{source}: #{e.message}")
    raise
  end

  def fetch_api_data(url)
    response = HTTParty.get(url)
    JSON.parse(response.body)
  rescue => e
    Rails.logger.error("Erro ao buscar dados da API: #{e.message}")
    nil
  end
end
