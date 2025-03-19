class CustomFailureApp < Devise::FailureApp
  def respond
    Rails.logger.debug "==== Falha na Autenticação ===="
    Rails.logger.debug "Razão: #{warden_message}"
    Rails.logger.debug "Estratégia: #{warden.winning_strategy&.class&.name}"
    super
  end
end
