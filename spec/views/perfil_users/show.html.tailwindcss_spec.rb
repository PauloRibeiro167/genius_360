require 'rails_helper'

RSpec.describe "perfil_users/show", type: :view do
  let(:perfil_user) { create(:perfil_user) }

  before(:each) do
    assign(:perfil_user, perfil_user)
  end

  it "exibe os atributos do perfil_user" do
    render
    expect(rendered).to have_selector(".card-title", text: "Perfil user")
    expect(rendered).to have_content("User")
    expect(rendered).to have_content("Perfil")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar perfil user")
    expect(rendered).to have_link("Voltar para perfil users")
    expect(rendered).to have_link("Desativar perfil user")
  end
end