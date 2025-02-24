require 'rails_helper'

RSpec.describe "perfil_users/new", type: :view do
  before(:each) do
    assign(:perfil_user, PerfilUser.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo perfil user")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{perfil_users_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("perfil_user[user_id]")
        expect(rendered).to have_field("perfil_user[perfil_id]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para perfil users")
  end
end