require 'rails_helper'

RSpec.describe "controller_permissions/show", type: :view do
  let(:controller_permission) { create(:controller_permission) }

  before(:each) do
    assign(:controller_permission, controller_permission)
  end

  it "exibe os atributos do controller_permission" do
    render
    expect(rendered).to have_selector(".card-title", text: "Controller permission")
    expect(rendered).to have_content("Name")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar controller permission")
    expect(rendered).to have_link("Voltar para controller permissions")
    expect(rendered).to have_link("Desativar controller permission")
  end
end