require "application_system_test_case"

class Consulta::ServidorFederalsTest < ApplicationSystemTestCase
  setup do
    @consulta_servidor_federal = consulta_servidor_federals(:one)
  end

  test "visiting the index" do
    visit consulta_servidor_federals_url
    assert_selector "h1", text: "Servidor federals"
  end

  test "should create servidor federal" do
    visit consulta_servidor_federals_url
    click_on "New servidor federal"

    fill_in "Cargo", with: @consulta_servidor_federal.cargo
    fill_in "Codigo funcao cargo", with: @consulta_servidor_federal.codigo_funcao_cargo
    fill_in "Codigo matricula formatado", with: @consulta_servidor_federal.codigo_matricula_formatado
    fill_in "Cpf", with: @consulta_servidor_federal.cpf
    fill_in "Cpf instituidor pensao", with: @consulta_servidor_federal.cpf_instituidor_pensao
    fill_in "Cpf representante pensao", with: @consulta_servidor_federal.cpf_representante_pensao
    fill_in "Descricao funcao cargo", with: @consulta_servidor_federal.descricao_funcao_cargo
    fill_in "Estado exercicio nome", with: @consulta_servidor_federal.estado_exercicio_nome
    fill_in "Estado exercicio sigla", with: @consulta_servidor_federal.estado_exercicio_sigla
    fill_in "Flag afastado", with: @consulta_servidor_federal.flag_afastado
    fill_in "Nome", with: @consulta_servidor_federal.nome
    fill_in "Nome instituidor pensao", with: @consulta_servidor_federal.nome_instituidor_pensao
    fill_in "Nome representante pensao", with: @consulta_servidor_federal.nome_representante_pensao
    fill_in "Orgao", with: @consulta_servidor_federal.orgao
    fill_in "Orgao exercicio codigo", with: @consulta_servidor_federal.orgao_exercicio_codigo
    fill_in "Orgao exercicio nome", with: @consulta_servidor_federal.orgao_exercicio_nome
    fill_in "Orgao exercicio sigla", with: @consulta_servidor_federal.orgao_exercicio_sigla
    fill_in "Orgao lotacao codigo", with: @consulta_servidor_federal.orgao_lotacao_codigo
    fill_in "Orgao lotacao nome", with: @consulta_servidor_federal.orgao_lotacao_nome
    fill_in "Orgao lotacao sigla", with: @consulta_servidor_federal.orgao_lotacao_sigla
    fill_in "Remuneracao apos deducoes", with: @consulta_servidor_federal.remuneracao_apos_deducoes
    fill_in "Remuneracao bruta", with: @consulta_servidor_federal.remuneracao_bruta
    fill_in "Salario", with: @consulta_servidor_federal.salario
    fill_in "Situacao", with: @consulta_servidor_federal.situacao
    fill_in "Tipo servidor", with: @consulta_servidor_federal.tipo_servidor
    click_on "Create Servidor federal"

    assert_text "Servidor federal was successfully created"
    click_on "Back"
  end

  test "should update Servidor federal" do
    visit consulta_servidor_federal_url(@consulta_servidor_federal)
    click_on "Edit this servidor federal", match: :first

    fill_in "Cargo", with: @consulta_servidor_federal.cargo
    fill_in "Codigo funcao cargo", with: @consulta_servidor_federal.codigo_funcao_cargo
    fill_in "Codigo matricula formatado", with: @consulta_servidor_federal.codigo_matricula_formatado
    fill_in "Cpf", with: @consulta_servidor_federal.cpf
    fill_in "Cpf instituidor pensao", with: @consulta_servidor_federal.cpf_instituidor_pensao
    fill_in "Cpf representante pensao", with: @consulta_servidor_federal.cpf_representante_pensao
    fill_in "Descricao funcao cargo", with: @consulta_servidor_federal.descricao_funcao_cargo
    fill_in "Estado exercicio nome", with: @consulta_servidor_federal.estado_exercicio_nome
    fill_in "Estado exercicio sigla", with: @consulta_servidor_federal.estado_exercicio_sigla
    fill_in "Flag afastado", with: @consulta_servidor_federal.flag_afastado
    fill_in "Nome", with: @consulta_servidor_federal.nome
    fill_in "Nome instituidor pensao", with: @consulta_servidor_federal.nome_instituidor_pensao
    fill_in "Nome representante pensao", with: @consulta_servidor_federal.nome_representante_pensao
    fill_in "Orgao", with: @consulta_servidor_federal.orgao
    fill_in "Orgao exercicio codigo", with: @consulta_servidor_federal.orgao_exercicio_codigo
    fill_in "Orgao exercicio nome", with: @consulta_servidor_federal.orgao_exercicio_nome
    fill_in "Orgao exercicio sigla", with: @consulta_servidor_federal.orgao_exercicio_sigla
    fill_in "Orgao lotacao codigo", with: @consulta_servidor_federal.orgao_lotacao_codigo
    fill_in "Orgao lotacao nome", with: @consulta_servidor_federal.orgao_lotacao_nome
    fill_in "Orgao lotacao sigla", with: @consulta_servidor_federal.orgao_lotacao_sigla
    fill_in "Remuneracao apos deducoes", with: @consulta_servidor_federal.remuneracao_apos_deducoes
    fill_in "Remuneracao bruta", with: @consulta_servidor_federal.remuneracao_bruta
    fill_in "Salario", with: @consulta_servidor_federal.salario
    fill_in "Situacao", with: @consulta_servidor_federal.situacao
    fill_in "Tipo servidor", with: @consulta_servidor_federal.tipo_servidor
    click_on "Update Servidor federal"

    assert_text "Servidor federal was successfully updated"
    click_on "Back"
  end

  test "should destroy Servidor federal" do
    visit consulta_servidor_federal_url(@consulta_servidor_federal)
    click_on "Destroy this servidor federal", match: :first

    assert_text "Servidor federal was successfully destroyed"
  end
end
