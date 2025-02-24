require 'rails_helper'

RSpec.describe "perfil_users/edit", type: :view do
  let(:perfil_user) { create(:perfil_user) }

  before(:each) do
    assign(:perfil_user, perfil_user)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{perfil_user_path(perfil_user)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("perfil_user[user_id]")
        expect(rendered).to have_field("perfil_user[perfil_id]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar perfil user")
    expect(rendered).to have_link("Voltar para perfil users")
  end
end