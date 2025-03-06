require 'rails_helper'

RSpec.describe "perfil_permissions/new", type: :view do
  before(:each) do
    assign(:perfil_permission, PerfilPermission.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo perfil permission")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{perfil_permissions_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("perfil_permission[perfil_id]")
        expect(rendered).to have_field("perfil_permission[permission_id]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para perfil permissions")
  end
end