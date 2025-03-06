require 'rails_helper'

RSpec.describe "permissions/edit", type: :view do
  let(:permission) { create(:permission) }

  before(:each) do
    assign(:permission, permission)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{permission_path(permission)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("permission[name]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar permission")
    expect(rendered).to have_link("Voltar para permissions")
  end
end