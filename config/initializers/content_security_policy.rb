# Configuração da Política de Segurança de Conteúdo

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :https
    policy.img_src     :self, :https
    policy.object_src  :none
    policy.script_src  :self, :https, :unsafe_inline, :unsafe_eval
    policy.style_src   :self, :https, :unsafe_inline
    policy.media_src   :self, :https, :data

    # Se você estiver usando versões mais recentes do webpack-dev-server, 
    # pode ser necessário especificar o porta aqui
    if Rails.env.development?
      policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035'
    end

    # Especifica a política de URI para relatórios de violação
    policy.report_uri "/csp/violation_report"
  end

  # Gera nonces para permitir scripts e estilos inline específicos
  config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }
  
  # Configurar como "report-only" apenas em desenvolvimento
  config.content_security_policy_report_only = Rails.env.development?
end
