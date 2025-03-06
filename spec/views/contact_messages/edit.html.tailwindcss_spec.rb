require 'rails_helper'

RSpec.describe "contact_messages/edit", type: :view do
  let(:contact_message) { create(:contact_message) }

  before(:each) do
    assign(:contact_message, contact_message)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{contact_message_path(contact_message)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("contact_message[name]")
        expect(rendered).to have_field("contact_message[email]")
        expect(rendered).to have_field("contact_message[message]")
        expect(rendered).to have_field("contact_message[status]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar contact message")
    expect(rendered).to have_link("Voltar para contact messages")
  end
end