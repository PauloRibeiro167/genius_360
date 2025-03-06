require 'rails_helper'

RSpec.describe "contact_messages/new", type: :view do
  before(:each) do
    assign(:contact_message, ContactMessage.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo contact message")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{contact_messages_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("contact_message[name]")
        expect(rendered).to have_field("contact_message[email]")
        expect(rendered).to have_field("contact_message[message]")
        expect(rendered).to have_field("contact_message[status]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para contact messages")
  end
end