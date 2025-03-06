require 'rails_helper'

RSpec.describe "permissions/new", type: :view do
  before(:each) do
    assign(:permission, Permission.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo permission")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{permissions_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("permission[name]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para permissions")
  end
end