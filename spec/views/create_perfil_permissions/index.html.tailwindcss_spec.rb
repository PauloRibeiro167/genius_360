require 'rails_helper'

RSpec.describe "create_perfil_permissions/index", type: :view do
  let(:records) { create_list(:create_perfil_permission, 2) }

  before(:each) do
    records
    @q = CreatePerfilPermission.ransack
    assign(:create_perfil_permissions, @q.result.page(1))
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Lista de create_perfil_permissions")
  end

  it "exibe a tabela com os registros" do
    render
    expect(rendered).to have_selector("table.table")
    expect(rendered).to have_selector("tr", count: CreatePerfilPermission.count + 2) # +2 para cabeçalho e filtros
  end

  it "exibe os links de ações" do
    render
    expect(rendered).to have_selector("i.fa-regular.fa-eye")
    expect(rendered).to have_selector("i.fa-regular.fa-edit")
    expect(rendered).to have_selector("i.fa-regular.fa-trash-can")
  end

  it "exibe o botão de novo registro" do
    render
    expect(rendered).to have_link("Novo CreatePerfilPermission", href: new_create_perfil_permission_path)
  end

  it "exibe o formulário de busca" do
    render
    expect(rendered).to have_selector("form")
    expect(rendered).to have_button("Pesquisar")
  end

  it "exibe a paginação" do
    render
    expect(rendered).to have_selector("nav.pagination")
  end
end