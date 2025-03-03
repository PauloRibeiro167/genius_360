class Public::PagesController < ApplicationController
  # Removido os skip_before_action que causavam erro
  
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
