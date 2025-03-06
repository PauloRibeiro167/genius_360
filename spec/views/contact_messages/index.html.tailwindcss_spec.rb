require 'rails_helper'

RSpec.describe "contact_messages/index", type: :view do
  let(:records) { create_list(:contact_message, 2) }

  before(:each) do
    records
    @q = ContactMessage.ransack
    assign(:contact_messages, @q.result.page(1))
  end

  it "exibe o título da página" do
    render
    expect(rendered).to have_content("Lista de contact_messages")
  end

  it "exibe a tabela com os registros" do
    render
    expect(rendered).to have_selector("table.table")
    expect(rendered).to have_selector("tr", count: ContactMessage.count + 2) # +2 para cabeçalho e filtros
  end

  it "exibe os links de ações" do
    render
    expect(rendered).to have_selector("i.fa-regular.fa-eye")
    expect(rendered).to have_selector("i.fa-regular.fa-edit")
    expect(rendered).to have_selector("i.fa-regular.fa-trash-can")
  end

  it "exibe o botão de novo registro" do
    render
    expect(rendered).to have_link("Novo ContactMessage", href: new_contact_message_path)
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