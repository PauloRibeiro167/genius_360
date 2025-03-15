module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_permissions
  end

  private

  def check_permissions
    # Ignora verificação para controllers públicos e devise
    return if controller_path.start_with?('public/') || devise_controller?
    return if controller_name == 'sessions' # Permite acesso ao controller de sessões
    return unless current_user

    controller_permission = ControllerPermission.find_by(name: controller_name)
    action_permission = ActionPermission.find_by(name: action_name)

    unless user_has_permission?(controller_permission, action_permission)
      Rails.logger.warn "Acesso negado para usuário #{current_user.email} em #{controller_name}##{action_name}"
      respond_to do |format|
        format.html do
          flash[:alert] = "Você não tem permissão para acessar este recurso."
          redirect_to root_path
        end
        format.json { render json: { error: 'Acesso não autorizado' }, status: :forbidden }
        format.turbo_stream do
          flash[:alert] = "Você não tem permissão para acessar este recurso."
          redirect_to root_path
        end
      end
    end
  end

  def user_has_permission?(controller_permission, action_permission)
    return false unless current_user.perfil

    required_permissions = []
    required_permissions << Permission.find_by(name: "#{controller_permission&.name}_#{action_permission&.name}")
    required_permissions << Permission.find_by(name: "#{controller_permission&.name}_all")

    current_user.perfil.permissions.where(id: required_permissions.compact).exists?
  end
end
