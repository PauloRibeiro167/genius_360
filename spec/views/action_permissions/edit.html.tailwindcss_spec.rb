require 'rails_helper'

RSpec.describe "action_permissions/edit", type: :view do
  let(:action_permission) { create(:action_permission) }

  before(:each) do
    assign(:action_permission, action_permission)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{action_permission_path(action_permission)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("action_permission[name]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar action permission")
    expect(rendered).to have_link("Voltar para action permissions")
  end
end