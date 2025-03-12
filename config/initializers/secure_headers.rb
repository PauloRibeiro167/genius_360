SecureHeaders::Configuration.default do |config|
  config.csp = {
    # Política mais permissiva para desenvolvimento
    default_src: %w('self' https:),
    font_src: %w('self' https: data: 'unsafe-inline'),
    img_src: %w('self' https: data:),
    style_src: %w('self' https: 'unsafe-inline'),
    script_src: %w('self' https: 'unsafe-inline'),
    frame_src: %w('self' https://www.google.com https://*.google.com),
    connect_src: %w('self' https:),
    object_src: %w('none'),
    report_uri: %w(/csp-violation)
  }

  # Configurações adicionais de segurança
  config.x_frame_options = "SAMEORIGIN"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w(strict-origin-when-cross-origin)
end
