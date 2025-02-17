require 'rails_helper'

RSpec.describe "perfils/new", type: :view do
  before(:each) do
    assign(:perfil, Perfil.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo perfil")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{perfils_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("perfil[name]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para perfils")
  end
end