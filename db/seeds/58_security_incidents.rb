puts "Criando registros de incidentes de segurança para demonstração..."

# Limpa registros existentes para evitar duplicações
# SecurityIncident.destroy_all (descomente se quiser limpar a tabela antes)

# Tipos de incidentes de segurança possíveis
incident_types = [
  "Login inválido",
  "Tentativa de força bruta",
  "Acesso não autorizado",
  "Tentativa de injeção SQL",
  "Cross-site scripting (XSS)",
  "Cross-site request forgery (CSRF)",
  "Ataque de negação de serviço (DoS)",
  "Tentativa de upload malicioso",
  "Scan de vulnerabilidades",
  "Vazamento de dados",
  "Acesso com credenciais vazadas",
  "Tentativa de phishing",
  "Uso de software não autorizado"
]

# Níveis de severidade
severities = ["Baixa", "Média", "Alta", "Crítica"]

# IPs fictícios para simulação
ips = [
  "192.168.1.254",
  "10.0.0.15",
  "172.16.8.122",
  "45.188.73.124",
  "187.45.123.45",
  "200.147.89.123",
  "189.75.34.212",
  "177.154.23.78",
  "64.233.160.0",
  "104.23.99.76",
  "35.227.192.15",
  "91.198.174.192"
]

# User agents comuns
user_agents = [
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Safari/605.1.15",
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 16_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Mobile/15E148 Safari/604.1",
  "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
  "Mozilla/5.0 (compatible; Bingbot/2.0; +http://www.bing.com/bingbot.htm)",
  "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)",
  "sqlmap/1.6.12#stable (http://sqlmap.org)",
  "Wget/1.21.3",
  "curl/7.87.0"
]

# Detalhes específicos por tipo de incidente
incident_details = {
  "Login inválido" => [
    "Tentativa de login com e-mail inválido: nonexistent@email.com",
    "Múltiplas tentativas de login com senha incorreta para usuário: admin@exemplo.com",
    "Tentativa de acesso com credenciais expiradas",
    "Acesso bloqueado após 5 tentativas incorretas"
  ],
  "Tentativa de força bruta" => [
    "Detectados 50+ tentativas de login em sequência",
    "Padrão de tentativas sistemáticas detectado no formulário de login",
    "Ataque automatizado identificado com mais de 100 requisições por minuto",
    "Script de força bruta detectado testando combinações sequenciais"
  ],
  "Acesso não autorizado" => [
    "Acesso à área administrativa a partir de IP não autorizado",
    "Tentativa de acesso a recursos restritos sem autenticação",
    "Login com credenciais vazadas de ex-funcionário",
    "Bypass detectado na verificação de permissões"
  ],
  "Tentativa de injeção SQL" => [
    "Detecção de caracteres suspeitos nos campos de pesquisa: ' OR 1=1 --",
    "Tentativa de injeção SQL no formulário de login",
    "Parâmetros de URL manipulados com comandos SQL",
    "Tentativa de extração de schema do banco via UNION SELECT"
  ],
  "Cross-site scripting (XSS)" => [
    "Script malicioso detectado no campo de comentários: <script>alert(1)</script>",
    "Tentativa de injeção de JavaScript em formulário de contato",
    "XSS detectado em parâmetros de URL",
    "Tentativa de execução de código remoto via evento onload"
  ],
  "Cross-site request forgery (CSRF)" => [
    "Tentativa de alteração de dados sem token CSRF válido",
    "Requisição suspeita originada de domínio externo",
    "Token CSRF ausente em requisição de alteração de senha",
    "Múltiplas tentativas de bypass da proteção CSRF"
  ],
  "Ataque de negação de serviço (DoS)" => [
    "Pico de 1000+ requisições por segundo de um único IP",
    "Conexões simultâneas excedendo limite de servidor",
    "Sobrecarga de recursos em operações intensivas",
    "Ataque coordenado identificado de múltiplos IPs"
  ],
  "Tentativa de upload malicioso" => [
    "Arquivo com extensão suspeita bloqueado: document.pdf.exe",
    "Detecção de código PHP em arquivo de imagem (JPEG)",
    "Upload de arquivo com assinatura modificada",
    "Script detectado em arquivo de planilha Excel"
  ],
  "Scan de vulnerabilidades" => [
    "Varredura sistemática de endpoints da API detectada",
    "Teste sequencial de URLs padrão de admin",
    "Solicitações para arquivos de configuração conhecidos (.env, web.config)",
    "Padrão de scan automático identificado testando vulnerabilidades comuns"
  ],
  "Vazamento de dados" => [
    "Acesso a volume anormal de registros em curto período",
    "Download em massa de arquivos confidenciais",
    "Exportação não autorizada de dados de clientes",
    "Consulta extraindo informação sensível em grande volume"
  ],
  "Acesso com credenciais vazadas" => [
    "Login detectado com credenciais encontradas em vazamentos conhecidos",
    "Acesso com senha comprometida identificada em banco de dados de vazamentos",
    "Conta acessada de localização geográfica incomum após vazamento",
    "Múltiplos acessos com credenciais listadas em sites de vazamentos"
  ],
  "Tentativa de phishing" => [
    "E-mail fraudulento enviado para funcionários solicitando credenciais",
    "Site falso imitando página de login da empresa detectado",
    "Tentativa de spear phishing direcionado para área financeira",
    "Link malicioso detectado em comunicação interna falsificada"
  ],
  "Uso de software não autorizado" => [
    "Software de acesso remoto não homologado detectado",
    "Instalação de ferramenta de mineração de criptomoedas",
    "Uso de VPN não autorizada para bypass de restrições",
    "Instalação de software de keylogging em estação de trabalho"
  ]
}

# Período para os incidentes
data_inicial = 1.year.ago
data_final = Date.today

# Número de incidentes a serem criados
incidentes_criados = 0
total_incidentes = 200 # Número de incidentes a serem criados

puts "Gerando #{total_incidentes} registros de incidentes de segurança..."

# Cria incidentes de segurança distribuídos ao longo do período
total_incidentes.times do
  # Seleciona um tipo de incidente aleatório
  incident_type = incident_types.sample
  
  # Determina a severidade baseada no tipo do incidente (alguns tipos tendem a ser mais graves)
  severity = case incident_type
             when "Ataque de negação de serviço (DoS)", "Vazamento de dados", "Tentativa de phishing"
               severities.last(2).sample # Alta ou Crítica
             when "Acesso não autorizado", "Tentativa de injeção SQL", "Cross-site scripting (XSS)"
               severities[1..2].sample  # Média ou Alta
             else
               severities.first(2).sample # Baixa ou Média
             end
  
  # Seleciona um IP e user agent
  source_ip = ips.sample
  user_agent = user_agents.sample
  
  # Seleciona um detalhe específico para o tipo de incidente
  details = incident_details[incident_type].sample
  
  # Define a data do incidente
  created_at = rand(data_inicial..data_final)
  
  # Cria o incidente
  incident = SecurityIncident.new(
    incident_type: incident_type,
    severity: severity,
    details: details,
    source_ip: source_ip,
    user_agent: user_agent,
    created_at: created_at,
    updated_at: created_at
  )
  
  if incident.save
    incidentes_criados += 1
    
    # Mostra progresso a cada 20 incidentes
    if (incidentes_criados % 20).zero?
      puts "... #{incidentes_criados} incidentes criados"
    end
  else
    puts "ERRO ao criar incidente de segurança: #{incident.errors.full_messages.join(', ')}"
  end
end

# Cria alguns incidentes críticos recentes
3.times do
  # Seleciona um incidente de alta gravidade
  incident_type = ["Ataque de negação de serviço (DoS)", "Vazamento de dados", "Acesso não autorizado"].sample
  details = incident_details[incident_type].sample + " [INCIDENTE DESTACADO]"
  
  incident = SecurityIncident.create!(
    incident_type: incident_type,
    severity: "Crítica",
    details: details,
    source_ip: ips.sample,
    user_agent: user_agents.sample,
    created_at: rand(1..7).days.ago
  )
  
  incidentes_criados += 1
  puts "Incidente crítico recente criado: #{incident.incident_type}"
end

# Calcula estatísticas
puts "\nEstatísticas gerais:"
puts "- Total de incidentes criados: #{incidentes_criados}"

# Incidentes por severidade
severities.each do |severity|
  count = SecurityIncident.where(severity: severity).count
  percentage = (count.to_f / incidentes_criados * 100).round(1)
  puts "- Severidade #{severity}: #{count} (#{percentage}%)"
end

# Incidentes por tipo
puts "\nTipos de incidentes mais comuns:"
types_count = SecurityIncident.group(:incident_type).count
top_5_types = types_count.sort_by { |_, count| -count }.first(5)

top_5_types.each do |type, count|
  percentage = (count.to_f / incidentes_criados * 100).round(1)
  puts "- #{type}: #{count} (#{percentage}%)"
end

# Incidentes por período
puts "\nIncidentes por período:"
meses = (0..11).map { |i| (Date.today - i.months).beginning_of_month }

meses.each do |mes|
  inicio_mes = mes.beginning_of_month
  fim_mes = mes.end_of_month
  count = SecurityIncident.where(created_at: inicio_mes..fim_mes).count
  
  if count > 0
    puts "- #{I18n.l(mes, format: '%B/%Y')}: #{count} incidentes"
  end
end

puts "\nRegistros de incidentes de segurança criados com sucesso!"