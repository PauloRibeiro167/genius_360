require 'rails_helper'

RSpec.describe "create_perfil_permissions/edit", type: :view do
  let(:create_perfil_permission) { create(:create_perfil_permission) }

  before(:each) do
    assign(:create_perfil_permission, create_perfil_permission)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{create_perfil_permission_path(create_perfil_permission)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("create_perfil_permission[perfil_id]")
        expect(rendered).to have_field("create_perfil_permission[permission_id]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar create perfil permission")
    expect(rendered).to have_link("Voltar para create perfil permissions")
  end
end