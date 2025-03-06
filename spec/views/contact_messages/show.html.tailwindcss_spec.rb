require 'rails_helper'

RSpec.describe "contact_messages/show", type: :view do
  let(:contact_message) { create(:contact_message) }

  before(:each) do
    assign(:contact_message, contact_message)
  end

  it "exibe os atributos do contact_message" do
    render
    expect(rendered).to have_selector(".card-title", text: "Contact message")
    expect(rendered).to have_content("Name")
    expect(rendered).to have_content("Email")
    expect(rendered).to have_content("Message")
    expect(rendered).to have_content("Status")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar contact message")
    expect(rendered).to have_link("Voltar para contact messages")
    expect(rendered).to have_link("Desativar contact message")
  end
end