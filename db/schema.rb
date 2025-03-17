# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_16_013638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "acessos", force: :cascade do |t|
    t.bigint "user_id"
    t.string "descricao"
    t.datetime "data_acesso"
    t.string "ip"
    t.string "modelo_dispositivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_acessos_on_user_id"
  end

  create_table "acompanhamentos", force: :cascade do |t|
    t.bigint "lead_id", null: false
    t.datetime "data_acompanhamento"
    t.text "resultado"
    t.string "tipo_acompanhamento"
    t.bigint "user_id"
    t.string "status"
    t.datetime "proxima_data"
    t.integer "prioridade"
    t.integer "duracao_minutos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_acompanhamento"], name: "index_acompanhamentos_on_data_acompanhamento"
    t.index ["lead_id"], name: "index_acompanhamentos_on_lead_id"
    t.index ["status"], name: "index_acompanhamentos_on_status"
    t.index ["user_id"], name: "index_acompanhamentos_on_user_id"
  end

  create_table "action_permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_data", force: :cascade do |t|
    t.string "source", null: false
    t.json "data", null: false
    t.datetime "collected_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collected_at"], name: "index_api_data_on_collected_at"
    t.index ["source"], name: "index_api_data_on_source"
  end

  create_table "avisos", force: :cascade do |t|
    t.string "titulo"
    t.text "descricao"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "avisos_users", force: :cascade do |t|
    t.bigint "aviso_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aviso_id", "user_id"], name: "index_avisos_users_on_aviso_id_and_user_id", unique: true
    t.index ["aviso_id"], name: "index_avisos_users_on_aviso_id"
    t.index ["user_id"], name: "index_avisos_users_on_user_id"
  end

  create_table "bancos", force: :cascade do |t|
    t.string "numero_identificador"
    t.string "nome"
    t.text "descricao"
    t.string "site"
    t.text "regras_gerais"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bancos_taxas", force: :cascade do |t|
    t.bigint "banco_id", null: false
    t.bigint "taxa_consignado_id", null: false
    t.decimal "taxa_preferencial", precision: 6, scale: 3
    t.boolean "ativo", default: true
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_bancos_taxas_on_ativo"
    t.index ["banco_id", "taxa_consignado_id"], name: "index_bancos_taxas_on_banco_id_and_taxa_consignado_id", unique: true
    t.index ["banco_id"], name: "index_bancos_taxas_on_banco_id"
    t.index ["discarded_at"], name: "index_bancos_taxas_on_discarded_at"
    t.index ["taxa_consignado_id"], name: "index_bancos_taxas_on_taxa_consignado_id"
  end

  create_table "beneficios", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.string "categoria", null: false
    t.boolean "consignavel", default: true
    t.decimal "margem_padrao", precision: 5, scale: 2
    t.decimal "margem_cartao_padrao", precision: 5, scale: 2
    t.string "fonte_pagadora"
    t.boolean "ativo", default: true
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_beneficios_on_ativo"
    t.index ["categoria"], name: "index_beneficios_on_categoria"
    t.index ["consignavel"], name: "index_beneficios_on_consignavel"
    t.index ["discarded_at"], name: "index_beneficios_on_discarded_at"
    t.index ["fonte_pagadora"], name: "index_beneficios_on_fonte_pagadora"
    t.index ["nome"], name: "index_beneficios_on_nome"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nome"
    t.string "cpf"
    t.string "email"
    t.string "telefone"
    t.string "endereco"
    t.string "cidade"
    t.string "estado"
    t.string "cep"
    t.text "observacoes"
    t.datetime "discarded_at"
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_clientes_on_cpf", unique: true
    t.index ["email"], name: "index_clientes_on_email"
    t.index ["nome"], name: "index_clientes_on_nome"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "message"
    t.string "request_type"
    t.string "status"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_contact_messages_on_discarded_at"
  end

  create_table "controller_permissions", force: :cascade do |t|
    t.string "controller_name", null: false
    t.string "action_name", null: false
    t.string "description"
    t.boolean "active", default: true
    t.bigint "permissions_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permissions_id"], name: "index_controller_permissions_on_permissions_id"
  end

  create_table "disponibilidades", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "dia_semana", null: false
    t.time "hora_inicio", null: false
    t.time "hora_fim", null: false
    t.boolean "disponivel", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_disponibilidades_on_user_id"
  end

  create_table "equipes", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.bigint "lider_id"
    t.string "tipo_equipe"
    t.string "regiao_atuacao"
    t.boolean "ativo", default: true
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_equipes_on_ativo"
    t.index ["discarded_at"], name: "index_equipes_on_discarded_at"
    t.index ["lider_id"], name: "index_equipes_on_lider_id"
    t.index ["nome"], name: "index_equipes_on_nome", unique: true
    t.index ["regiao_atuacao"], name: "index_equipes_on_regiao_atuacao"
    t.index ["tipo_equipe"], name: "index_equipes_on_tipo_equipe"
  end

  create_table "equipes_users", force: :cascade do |t|
    t.bigint "equipe_id", null: false
    t.bigint "user_id", null: false
    t.string "cargo"
    t.date "data_entrada"
    t.date "data_saida"
    t.boolean "ativo", default: true
    t.decimal "meta_individual", precision: 10, scale: 2
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_equipes_users_on_ativo"
    t.index ["cargo"], name: "index_equipes_users_on_cargo"
    t.index ["discarded_at"], name: "index_equipes_users_on_discarded_at"
    t.index ["equipe_id", "user_id", "cargo", "data_entrada"], name: "idx_equipes_users_unique_active", unique: true, where: "(ativo = true)"
    t.index ["equipe_id"], name: "index_equipes_users_on_equipe_id"
    t.index ["user_id"], name: "index_equipes_users_on_user_id"
  end

  create_table "financial_transactions", force: :cascade do |t|
    t.string "tipo", default: "entrada", null: false
    t.decimal "valor", precision: 15, scale: 2, null: false
    t.string "descricao"
    t.string "categoria"
    t.date "data_competencia", null: false
    t.date "data_vencimento"
    t.date "data_pagamento"
    t.string "forma_pagamento"
    t.string "status", default: "pendente"
    t.string "numero_documento"
    t.string "documento_path"
    t.bigint "user_id", null: false
    t.bigint "aprovado_por_id"
    t.string "entidade_type"
    t.bigint "entidade_id"
    t.string "conta_bancaria"
    t.string "centro_custo"
    t.text "observacoes"
    t.datetime "discarded_at"
    t.string "numero_parcela"
    t.bigint "transacao_relacionada_id"
    t.boolean "reembolsavel", default: false
    t.bigint "solicitante_id_id"
    t.string "status_reembolso"
    t.date "data_solicitacao_reembolso"
    t.text "justificativa_reembolso"
    t.string "comprovante_reembolso_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aprovado_por_id"], name: "index_financial_transactions_on_aprovado_por_id"
    t.index ["categoria"], name: "index_financial_transactions_on_categoria"
    t.index ["conta_bancaria"], name: "index_financial_transactions_on_conta_bancaria"
    t.index ["data_competencia"], name: "index_financial_transactions_on_data_competencia"
    t.index ["data_solicitacao_reembolso"], name: "index_financial_transactions_on_data_solicitacao_reembolso"
    t.index ["data_vencimento"], name: "index_financial_transactions_on_data_vencimento"
    t.index ["discarded_at"], name: "index_financial_transactions_on_discarded_at"
    t.index ["entidade_type", "entidade_id"], name: "index_financial_transactions_on_entidade"
    t.index ["reembolsavel"], name: "index_financial_transactions_on_reembolsavel"
    t.index ["solicitante_id_id"], name: "index_financial_transactions_on_solicitante_id_id"
    t.index ["status"], name: "index_financial_transactions_on_status"
    t.index ["status_reembolso"], name: "index_financial_transactions_on_status_reembolso"
    t.index ["tipo"], name: "index_financial_transactions_on_tipo"
    t.index ["transacao_relacionada_id"], name: "index_financial_transactions_on_transacao_relacionada_id"
    t.index ["user_id"], name: "index_financial_transactions_on_user_id"
  end

  create_table "hierarquias", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "nivel", null: false
    t.text "descricao"
    t.boolean "ativo", default: true, null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_hierarquias_on_discarded_at"
    t.index ["nivel"], name: "index_hierarquias_on_nivel", unique: true
    t.index ["nome"], name: "index_hierarquias_on_nome", unique: true
  end

  create_table "leads", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "telefone"
    t.string "status"
    t.string "origem"
    t.text "observacoes"
    t.jsonb "dados_extras", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.boolean "read", default: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_messages_on_discarded_at"
    t.index ["read"], name: "index_messages_on_read"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "meta", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "tipo_meta"
    t.decimal "valor_meta"
    t.date "data_inicio"
    t.date "data_fim"
    t.string "status", default: "em andamento"
    t.text "observacoes"
    t.datetime "discarded_at"
    t.datetime "modified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meta_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "type"
    t.bigint "user_id", null: false
    t.json "data"
    t.datetime "read_at"
    t.string "url"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "parceiros", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "percentual_comissao", precision: 5, scale: 2, default: "0.0"
    t.string "chave_pix"
    t.string "banco"
    t.string "agencia"
    t.string "conta"
    t.string "tipo_conta", default: "corrente"
    t.string "titular_conta"
    t.string "cpf_titular"
    t.string "email_titular"
    t.string "telefone_titular"
    t.string "endereco_titular"
    t.string "cidade_titular"
    t.string "estado_titular"
    t.string "cep_titular"
    t.datetime "discarded_at"
    t.string "periodicidade_pagamento", default: "mensal"
    t.integer "dia_pagamento", default: 5
    t.decimal "valor_minimo_pagamento", precision: 10, scale: 2, default: "0.0"
    t.string "codigo_parceiro", null: false
    t.string "qrcode_path"
    t.string "url_indicacao"
    t.boolean "ativo", default: true
    t.integer "nivel_parceiro", default: 1
    t.text "observacoes"
    t.integer "total_indicacoes", default: 0
    t.integer "indicacoes_convertidas", default: 0
    t.decimal "valor_total_comissoes", precision: 10, scale: 2, default: "0.0"
    t.datetime "data_aprovacao"
    t.datetime "proximo_pagamento"
    t.datetime "ultimo_pagamento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_parceiros_on_ativo"
    t.index ["codigo_parceiro"], name: "index_parceiros_on_codigo_parceiro", unique: true
    t.index ["discarded_at"], name: "index_parceiros_on_discarded_at"
    t.index ["proximo_pagamento"], name: "index_parceiros_on_proximo_pagamento"
    t.index ["user_id"], name: "index_parceiros_on_user_id"
  end

  create_table "participantes", force: :cascade do |t|
    t.bigint "reuniao_id", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "pendente"
    t.text "observacoes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reuniao_id", "user_id"], name: "index_participantes_on_reuniao_id_and_user_id", unique: true
    t.index ["reuniao_id"], name: "index_participantes_on_reuniao_id"
    t.index ["user_id"], name: "index_participantes_on_user_id"
  end

  create_table "perfil_permissions", force: :cascade do |t|
    t.bigint "perfil_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id", "permission_id"], name: "index_perfil_permissions_on_perfil_id_and_permission_id", unique: true
    t.index ["perfil_id"], name: "index_perfil_permissions_on_perfil_id"
    t.index ["permission_id"], name: "index_perfil_permissions_on_permission_id"
  end

  create_table "perfil_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "perfil_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id"], name: "index_perfil_users_on_perfil_id"
    t.index ["user_id"], name: "index_perfil_users_on_user_id"
  end

  create_table "perfils", force: :cascade do |t|
    t.string "name"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_permissions_on_discarded_at"
  end

  create_table "progresso_vendas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "data"
    t.decimal "valor_vendas", precision: 10, scale: 2
    t.integer "quantidade_vendas", default: 0
    t.decimal "meta_valor", precision: 10, scale: 2
    t.integer "meta_quantidade"
    t.decimal "percentual_comissao", precision: 5, scale: 2
    t.decimal "valor_comissao", precision: 10, scale: 2
    t.string "status", default: "pendente"
    t.bigint "equipe_id"
    t.string "canal_venda"
    t.string "regiao"
    t.decimal "ticket_medio", precision: 10, scale: 2
    t.decimal "taxa_conversao", precision: 5, scale: 2
    t.text "observacoes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data"], name: "index_progresso_vendas_on_data"
    t.index ["equipe_id"], name: "index_progresso_vendas_on_equipe_id"
    t.index ["status"], name: "index_progresso_vendas_on_status"
    t.index ["user_id"], name: "index_progresso_vendas_on_user_id"
  end

  create_table "proposta", force: :cascade do |t|
    t.string "numero"
    t.string "status"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reuniaos", force: :cascade do |t|
    t.string "titulo"
    t.text "descricao"
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.string "local_fisico"
    t.string "sala"
    t.string "link_reuniao"
    t.string "plataforma_virtual"
    t.string "status", default: "agendada"
    t.bigint "organizador_id", null: false
    t.string "memorando_pdf"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizador_id"], name: "index_reuniaos_on_organizador_id"
  end

  create_table "security_incidents", force: :cascade do |t|
    t.string "incident_type"
    t.string "severity"
    t.text "details"
    t.string "source_ip"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxas_beneficios", force: :cascade do |t|
    t.bigint "taxa_consignado_id", null: false
    t.bigint "beneficio_id", null: false
    t.boolean "aplicavel", default: true
    t.text "regras_especiais"
    t.boolean "ativo", default: true
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_taxas_beneficios_on_ativo"
    t.index ["beneficio_id"], name: "index_taxas_beneficios_on_beneficio_id"
    t.index ["discarded_at"], name: "index_taxas_beneficios_on_discarded_at"
    t.index ["taxa_consignado_id", "beneficio_id"], name: "index_taxas_beneficios_on_taxa_consignado_id_and_beneficio_id", unique: true
    t.index ["taxa_consignado_id"], name: "index_taxas_beneficios_on_taxa_consignado_id"
  end

  create_table "taxas_consignados", force: :cascade do |t|
    t.string "nome", null: false
    t.decimal "taxa_minima", precision: 6, scale: 3
    t.decimal "taxa_maxima", precision: 6, scale: 3
    t.integer "prazo_minimo", default: 1
    t.integer "prazo_maximo"
    t.decimal "margem_emprestimo", precision: 5, scale: 2
    t.decimal "margem_cartao", precision: 5, scale: 2
    t.string "tipo_operacao"
    t.date "data_vigencia_inicio"
    t.date "data_vigencia_fim"
    t.boolean "ativo", default: true
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_taxas_consignados_on_ativo"
    t.index ["data_vigencia_fim"], name: "index_taxas_consignados_on_data_vigencia_fim"
    t.index ["data_vigencia_inicio"], name: "index_taxas_consignados_on_data_vigencia_inicio"
    t.index ["discarded_at"], name: "index_taxas_consignados_on_discarded_at"
    t.index ["nome"], name: "index_taxas_consignados_on_nome"
    t.index ["tipo_operacao"], name: "index_taxas_consignados_on_tipo_operacao"
  end

  create_table "tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "cpf", null: false
    t.string "phone", null: false
    t.boolean "admin", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "last_known_ip"
    t.string "location"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "perfil_id", null: false
    t.datetime "discarded_at"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["perfil_id"], name: "index_users_on_perfil_id"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendas", force: :cascade do |t|
    t.bigint "lead_id", null: false
    t.bigint "cliente_id", null: false
    t.bigint "user_id", null: false
    t.decimal "valor_venda"
    t.datetime "data_venda"
    t.datetime "data_contratacao"
    t.boolean "indicacao", default: false
    t.bigint "parceiro_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_vendas_on_cliente_id"
    t.index ["lead_id"], name: "index_vendas_on_lead_id"
    t.index ["parceiro_id"], name: "index_vendas_on_parceiro_id"
    t.index ["user_id"], name: "index_vendas_on_user_id"
  end

  add_foreign_key "acessos", "users"
  add_foreign_key "acompanhamentos", "leads"
  add_foreign_key "acompanhamentos", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "avisos_users", "avisos"
  add_foreign_key "avisos_users", "users"
  add_foreign_key "bancos_taxas", "bancos"
  add_foreign_key "bancos_taxas", "taxas_consignados", column: "taxa_consignado_id"
  add_foreign_key "controller_permissions", "permissions", column: "permissions_id"
  add_foreign_key "disponibilidades", "users"
  add_foreign_key "equipes", "users", column: "lider_id"
  add_foreign_key "equipes_users", "equipes"
  add_foreign_key "equipes_users", "users"
  add_foreign_key "financial_transactions", "users"
  add_foreign_key "financial_transactions", "users", column: "aprovado_por_id"
  add_foreign_key "financial_transactions", "users", column: "solicitante_id_id"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "meta", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "parceiros", "users"
  add_foreign_key "participantes", "reuniaos"
  add_foreign_key "participantes", "users"
  add_foreign_key "perfil_permissions", "perfils"
  add_foreign_key "perfil_permissions", "permissions"
  add_foreign_key "perfil_users", "perfils"
  add_foreign_key "perfil_users", "users"
  add_foreign_key "progresso_vendas", "equipes"
  add_foreign_key "progresso_vendas", "users"
  add_foreign_key "reuniaos", "users", column: "organizador_id"
  add_foreign_key "taxas_beneficios", "beneficios"
  add_foreign_key "taxas_beneficios", "taxas_consignados", column: "taxa_consignado_id"
  add_foreign_key "tokens", "users"
  add_foreign_key "users", "perfils"
  add_foreign_key "vendas", "clientes"
  add_foreign_key "vendas", "leads"
  add_foreign_key "vendas", "parceiros"
  add_foreign_key "vendas", "users"
end
