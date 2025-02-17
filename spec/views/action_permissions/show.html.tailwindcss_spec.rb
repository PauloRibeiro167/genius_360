require 'rails_helper'

RSpec.describe "action_permissions/show", type: :view do
  let(:action_permission) { create(:action_permission) }

  before(:each) do
    assign(:action_permission, action_permission)
  end

  it "exibe os atributos do action_permission" do
    render
    expect(rendered).to have_selector(".card-title", text: "Action permission")
    expect(rendered).to have_content("Name")
  end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_link("Editar action permission")
    expect(rendered).to have_link("Voltar para action permissions")
    expect(rendered).to have_link("Desativar action permission")
  end
end