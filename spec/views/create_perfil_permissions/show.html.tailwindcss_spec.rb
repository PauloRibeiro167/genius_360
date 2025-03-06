require 'rails_helper'

RSpec.describe "create_perfil_permissions/show", type: :view do
  let(:create_perfil_permission) { create(:create_perfil_permission) }

  before(:each) do
    assign(:create_perfil_permission, create_perfil_permission)
  end

  it "exibe os atributos do create_perfil_permission" do
    render
    expect(rendered).to have_selector(".card-title", text: "Create perfil permission")
    expect(rendered).to have_content("Perfil")
    expect(rendered).to have_content("Permission")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar create perfil permission")
    expect(rendered).to have_link("Voltar para create perfil permissions")
    expect(rendered).to have_link("Desativar create perfil permission")
  end
end