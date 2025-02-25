module Api
  class BaseController < ActionController::API
    include ActionController::MimeResponds

    before_action :authenticate_request

    private

    def authenticate_request
      unless valid_request?
        render json: { error: "Não autorizado" }, status: :unauthorized
      end
    end

    def valid_request?
      true # implementação temporária
    end

    def current_user
      @current_user ||= nil # implementação temporária
    end
  end
end
