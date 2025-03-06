require 'rails_helper'

RSpec.describe "perfils/show", type: :view do
  let(:perfil) { create(:perfil) }

  before(:each) do
    assign(:perfil, perfil)
  end

  it "exibe os atributos do perfil" do
    render
    expect(rendered).to have_selector(".card-title", text: "Perfil")
    expect(rendered).to have_content("Name")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar perfil")
    expect(rendered).to have_link("Voltar para perfils")
    expect(rendered).to have_link("Desativar perfil")
  end
end