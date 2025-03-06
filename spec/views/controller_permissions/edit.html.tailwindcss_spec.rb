require 'rails_helper'

RSpec.describe "controller_permissions/edit", type: :view do
  let(:controller_permission) { create(:controller_permission) }

  before(:each) do
    assign(:controller_permission, controller_permission)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{controller_permission_path(controller_permission)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("controller_permission[name]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar controller permission")
    expect(rendered).to have_link("Voltar para controller permissions")
  end
end