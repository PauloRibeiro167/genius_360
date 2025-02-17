require 'rails_helper'

RSpec.describe "action_permissions/new", type: :view do
  before(:each) do
    assign(:action_permission, ActionPermission.new)
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Novo action permission")
  end

  it "exibe o formulário de criação" do
    render
    expect(rendered).to have_selector("form[action='#{action_permissions_path}']")
  end

  it "exibe todos os campos do formulário" do
    render
      expect(rendered).to have_field("action_permission[name]")
    end

  it "exibe o botão de voltar" do
    render
    expect(rendered).to have_link("Voltar para action permissions")
  end
end