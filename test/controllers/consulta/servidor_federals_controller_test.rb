require "test_helper"

class Consulta::ServidorFederalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consulta_servidor_federal = consulta_servidor_federals(:one)
  end

  test "should get index" do
    get consulta_servidor_federals_url
    assert_response :success
  end

  test "should get new" do
    get new_consulta_servidor_federal_url
    assert_response :success
  end

  test "should create consulta_servidor_federal" do
    assert_difference("Consulta::ServidorFederal.count") do
      post consulta_servidor_federals_url, params: { consulta_servidor_federal: { cargo: @consulta_servidor_federal.cargo, codigo_funcao_cargo: @consulta_servidor_federal.codigo_funcao_cargo, codigo_matricula_formatado: @consulta_servidor_federal.codigo_matricula_formatado, cpf: @consulta_servidor_federal.cpf, cpf_instituidor_pensao: @consulta_servidor_federal.cpf_instituidor_pensao, cpf_representante_pensao: @consulta_servidor_federal.cpf_representante_pensao, descricao_funcao_cargo: @consulta_servidor_federal.descricao_funcao_cargo, estado_exercicio_nome: @consulta_servidor_federal.estado_exercicio_nome, estado_exercicio_sigla: @consulta_servidor_federal.estado_exercicio_sigla, flag_afastado: @consulta_servidor_federal.flag_afastado, nome: @consulta_servidor_federal.nome, nome_instituidor_pensao: @consulta_servidor_federal.nome_instituidor_pensao, nome_representante_pensao: @consulta_servidor_federal.nome_representante_pensao, orgao: @consulta_servidor_federal.orgao, orgao_exercicio_codigo: @consulta_servidor_federal.orgao_exercicio_codigo, orgao_exercicio_nome: @consulta_servidor_federal.orgao_exercicio_nome, orgao_exercicio_sigla: @consulta_servidor_federal.orgao_exercicio_sigla, orgao_lotacao_codigo: @consulta_servidor_federal.orgao_lotacao_codigo, orgao_lotacao_nome: @consulta_servidor_federal.orgao_lotacao_nome, orgao_lotacao_sigla: @consulta_servidor_federal.orgao_lotacao_sigla, remuneracao_apos_deducoes: @consulta_servidor_federal.remuneracao_apos_deducoes, remuneracao_bruta: @consulta_servidor_federal.remuneracao_bruta, salario: @consulta_servidor_federal.salario, situacao: @consulta_servidor_federal.situacao, tipo_servidor: @consulta_servidor_federal.tipo_servidor } }
    end

    assert_redirected_to consulta_servidor_federal_url(Consulta::ServidorFederal.last)
  end

  test "should show consulta_servidor_federal" do
    get consulta_servidor_federal_url(@consulta_servidor_federal)
    assert_response :success
  end

  test "should get edit" do
    get edit_consulta_servidor_federal_url(@consulta_servidor_federal)
    assert_response :success
  end

  test "should update consulta_servidor_federal" do
    patch consulta_servidor_federal_url(@consulta_servidor_federal), params: { consulta_servidor_federal: { cargo: @consulta_servidor_federal.cargo, codigo_funcao_cargo: @consulta_servidor_federal.codigo_funcao_cargo, codigo_matricula_formatado: @consulta_servidor_federal.codigo_matricula_formatado, cpf: @consulta_servidor_federal.cpf, cpf_instituidor_pensao: @consulta_servidor_federal.cpf_instituidor_pensao, cpf_representante_pensao: @consulta_servidor_federal.cpf_representante_pensao, descricao_funcao_cargo: @consulta_servidor_federal.descricao_funcao_cargo, estado_exercicio_nome: @consulta_servidor_federal.estado_exercicio_nome, estado_exercicio_sigla: @consulta_servidor_federal.estado_exercicio_sigla, flag_afastado: @consulta_servidor_federal.flag_afastado, nome: @consulta_servidor_federal.nome, nome_instituidor_pensao: @consulta_servidor_federal.nome_instituidor_pensao, nome_representante_pensao: @consulta_servidor_federal.nome_representante_pensao, orgao: @consulta_servidor_federal.orgao, orgao_exercicio_codigo: @consulta_servidor_federal.orgao_exercicio_codigo, orgao_exercicio_nome: @consulta_servidor_federal.orgao_exercicio_nome, orgao_exercicio_sigla: @consulta_servidor_federal.orgao_exercicio_sigla, orgao_lotacao_codigo: @consulta_servidor_federal.orgao_lotacao_codigo, orgao_lotacao_nome: @consulta_servidor_federal.orgao_lotacao_nome, orgao_lotacao_sigla: @consulta_servidor_federal.orgao_lotacao_sigla, remuneracao_apos_deducoes: @consulta_servidor_federal.remuneracao_apos_deducoes, remuneracao_bruta: @consulta_servidor_federal.remuneracao_bruta, salario: @consulta_servidor_federal.salario, situacao: @consulta_servidor_federal.situacao, tipo_servidor: @consulta_servidor_federal.tipo_servidor } }
    assert_redirected_to consulta_servidor_federal_url(@consulta_servidor_federal)
  end

  test "should destroy consulta_servidor_federal" do
    assert_difference("Consulta::ServidorFederal.count", -1) do
      delete consulta_servidor_federal_url(@consulta_servidor_federal)
    end

    assert_redirected_to consulta_servidor_federals_url
  end
end
