class Public::PagesController < ApplicationController
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
