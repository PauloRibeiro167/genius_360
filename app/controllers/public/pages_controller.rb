class Public::PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_permissions
  layout 'application'
  
  def index
  end

  def sobre
  end

  def servico
  end

  def precos
  end

  def contato
    @contact_message = ContactMessage.new
  end
end
