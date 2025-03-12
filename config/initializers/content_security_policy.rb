# Be sure to restart your server when you modify this file.

# Define a política de segurança de conteúdo para a aplicação
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data, :unsafe_inline
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https, :unsafe_inline
  policy.style_src   :self, :https, :unsafe_inline
  
  # Permitir frames do Google Maps
  policy.frame_src   :self, 'https://www.google.com', 'https://*.google.com'
  
  # Permitir conexões com fontes externas
  policy.connect_src :self, :https
  
  # Reportar violações CSP - opcional
  # policy.report_uri "/csp-violation-report-endpoint"
end

# Gera nonces para permitir scripts inline específicos
Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Permite que elementos específicos usem um nonce CSP
Rails.application.config.content_security_policy_nonce_directives = %w(script-src style-src)

# Descomente para ativar o modo de relatório sem bloqueio
Rails.application.config.content_security_policy_report_only = true
