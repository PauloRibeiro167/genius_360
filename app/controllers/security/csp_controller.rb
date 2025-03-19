class CspController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:violation_report]

  def violation_report
    begin
      report = JSON.parse(request.body.read)['csp-report']
      
      if violation_is_serious?(report)
        # Registrar em log
        Rails.logger.error "VIOLAÇÃO CSP CRÍTICA: documento=#{report['document-uri']}, bloqueado=#{report['blocked-uri']}, diretiva=#{report['violated-directive']}"
        
        # Opcionalmente, salvar no banco de dados
        SecurityIncident.create!(
          incident_type: 'csp_violation',
          severity: 'high',
          details: report.to_json,
          source_ip: request.remote_ip,
          user_agent: request.user_agent
        ) if defined?(SecurityIncident)
        
        # Opcionalmente, notificar a equipe de segurança
        # NotificationService.alert_security_team("Violação CSP crítica detectada", report)
      end
    rescue => e
      Rails.logger.error "Erro ao processar relatório CSP: #{e.message}"
    end
    
    head :ok
  end
  
  private
  
  def violation_is_serious?(report)
    return false unless report.present?
    
    # Critérios para considerar uma violação séria:
    
    # 1. Scripts de fontes não confiáveis
    if report['violated-directive']&.include?('script-src') && 
       !['self', 'https:', "'unsafe-inline'"].any? { |safe| report['blocked-uri']&.include?(safe) }
      return true
    end
    
    # 2. Tentativa de injeção de objeto
    if report['violated-directive']&.include?('object-src')
      return true
    end
    
    # 3. Violações relacionadas a EVAL (geralmente perigosas)
    if report['violated-directive']&.include?("'unsafe-eval'")
      return true
    end
    
    # 4. Tentativas de conexão com domínios suspeitos
    dangerous_domains = ['evil.com', 'malware.org', 'phishing.net'] # adicione domínios suspeitos
    if dangerous_domains.any? { |domain| report['blocked-uri']&.include?(domain) }
      return true
    end
    
    # Se não atender a nenhum critério, não é considerado grave
    false
  end
end
