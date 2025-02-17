require 'rails_helper'

RSpec.describe "perfils/edit", type: :view do
  let(:perfil) { create(:perfil) }

  before(:each) do
    assign(:perfil, perfil)
  end

  it "exibe o formulário de edição" do
    render
    expect(rendered).to have_selector("form[action='#{perfil_path(perfil)}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("perfil[name]")
    end

  it "exibe os botões de ação" do
    render
    expect(rendered).to have_button("Salvar")
    expect(rendered).to have_link("Mostrar perfil")
    expect(rendered).to have_link("Voltar para perfils")
  end
end