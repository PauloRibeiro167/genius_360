require 'rails_helper'

RSpec.describe "create_perfil_permissions/new", type: :view do
  before(:each) do
    assign(:create_perfil_permission, CreatePerfilPermission.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo create perfil permission")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{create_perfil_permissions_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("create_perfil_permission[perfil_id]")
        expect(rendered).to have_field("create_perfil_permission[permission_id]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para create perfil permissions")
  end
end