require 'rails_helper'

RSpec.describe "permissions/show", type: :view do
  let(:permission) { create(:permission) }

  before(:each) do
    assign(:permission, permission)
  end

  it "exibe os atributos do permission" do
    render
    expect(rendered).to have_selector(".card-title", text: "Permission")
    expect(rendered).to have_content("Name")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar permission")
    expect(rendered).to have_link("Voltar para permissions")
    expect(rendered).to have_link("Desativar permission")
  end
end