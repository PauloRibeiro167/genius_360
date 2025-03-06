require 'rails_helper'

RSpec.describe "controller_permissions/new", type: :view do
  before(:each) do
    assign(:controller_permission, ControllerPermission.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo controller permission")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{controller_permissions_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("controller_permission[name]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para controller permissions")
  end
end