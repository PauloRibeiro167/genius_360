require "net/http"
require "json"
require "fileutils"

class ServPiController
  def build_url(id_unidade_gestora, exercicio, pagina = 1, qtde_por_pagina = 100)
    base_url = "https://sistemas.tce.pi.gov.br/api/portaldacidadania/servidores/#{id_unidade_gestora}/#{exercicio}/lista"
    query_params = {
      pagina: pagina,
      qtdePorPagina: qtde_por_pagina,
      ascDesc: 1
    }
    uri = URI(base_url)
    uri.query = URI.encode_www_form(query_params)
    uri
  end

  def fetch_data(id_unidade_gestora, exercicio, pagina = 1)
    uri = build_url(id_unidade_gestora, exercicio, pagina)
    response = Net::HTTP.get_response(uri)
    puts "Fetching URL: #{uri}"
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"
    return nil if response.code.to_i != 200
    JSON.parse(response.body)
  rescue JSON::ParserError => e
    puts "Erro ao analisar JSON: #{e.message}"
    nil
  rescue StandardError => e
    puts "Erro ao buscar dados: #{e.message}"
    nil
  end

  def run
    municipios = [ 1473, 1474, 1475, 1476, 1477, 1478, 118, 1480, 1481, 1482, 1483, 1484, 1485, 1486, 1487, 1488, 1489, 1490, 1491, 119, 1493, 1494, 1495, 1496, 1497, 1498, 1499, 1500, 1501, 1502, 1503, 1504, 1505, 1506, 1507, 1508, 1509, 1510, 1511, 1512, 1513, 1514, 1515, 1516, 1517, 1518, 120, 1520, 1521, 1522, 1523, 1528, 1529, 1530, 1531, 1532, 1533, 1534, 1535, 1536, 1537, 1538, 1539, 1540, 1541, 1542, 1543, 1544, 1545, 1546, 1547, 1548, 1549, 1550, 121, 1552, 1553, 1554, 122, 1556, 1557, 1558, 1559, 1560, 1561, 1562, 1563, 1564, 1565, 1566, 1567, 1568, 1569, 1570, 1571, 1572, 1573, 1574, 1575, 1576, 1577, 1578, 1579, 1580, 1581, 1582, 1583, 1584, 1585, 1586, 1587, 1588, 1589, 1590, 123, 124, 1593, 1594, 1595, 1596, 1597, 1598, 1599, 1600, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1608, 1767, 1609, 1610, 1611, 1612, 1613, 125, 1615, 1616, 1617, 1618, 1619, 1620, 1621, 1622, 126, 1624, 1625, 1626, 127, 1628, 128, 1630, 129, 1632, 1633, 1634, 130, 1636, 1637, 1638, 1639, 1640, 1641, 1642, 1643, 644, 1645, 1646, 1647, 1648, 1649, 1650, 1651, 1652, 1653, 1654, 1655, 1656, 1657, 1658, 1659, 1660, 1661, 1662, 1663, 1664, 1665, 131, 1667, 1668, 1669, 1670, 1671, 1672, 1673, 1681, 1682, 1683, 1684, 1685, 1686, 133, 134, 1689, 1690, 1691, 1692, 1693, 1694, 1695 ]
    exercicio = 2024

    dir_name = "/workspaces/sispred/app/services/database"
    FileUtils.mkdir_p(dir_name)

    all_data = []

    municipios.each do |id_unidade_gestora|
      page = 1

      loop do
        data = fetch_data(id_unidade_gestora, exercicio, page)
        break if data.nil?

        if !data.is_a?(Array) || data.empty?
          puts "Nenhum dado retornado para a página #{page} do município #{id_unidade_gestora}."
          break
        end

        all_data.concat(data)

        puts "Número de registros retornados na página #{page} para o município #{id_unidade_gestora}: #{data.size}"

        page += 1
      end
    end

    if all_data.empty?
      puts "Nenhum dado foi acumulado."
    else
      begin
        file_path = "#{dir_name}/SPDPI.json"
        File.open(file_path, "w") do |file|
          file.write(JSON.pretty_generate(all_data))
        end
        puts "Todos os dados foram armazenados em #{file_path}"
      rescue StandardError => e
        puts "Erro ao salvar os dados no arquivo: #{e.message}"
      end
    end
  end
end
