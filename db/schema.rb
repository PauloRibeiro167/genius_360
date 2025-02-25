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

ActiveRecord::Schema[8.0].define(version: 2025_02_25_153639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_action_permissions_on_discarded_at"
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
    t.datetime "collected_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collected_at"], name: "index_api_data_on_collected_at"
    t.index ["source"], name: "index_api_data_on_source"
  end

  create_table "avisos", force: :cascade do |t|
    t.string "titulo"
    t.text "descricao"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_controller_permissions_on_discarded_at"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "recipient_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.integer "sender_id"
    t.index ["discarded_at"], name: "index_messages_on_discarded_at"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "url"
    t.json "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "perfil_permissions", force: :cascade do |t|
    t.bigint "perfil_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_perfil_permissions_on_discarded_at"
    t.index ["perfil_id", "permission_id"], name: "index_perfil_permissions_on_perfil_id_and_permission_id", unique: true
    t.index ["perfil_id"], name: "index_perfil_permissions_on_perfil_id"
    t.index ["permission_id"], name: "index_perfil_permissions_on_permission_id"
  end

  create_table "perfil_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "perfil_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_perfil_users_on_discarded_at"
    t.index ["perfil_id"], name: "index_perfil_users_on_perfil_id"
    t.index ["user_id"], name: "index_perfil_users_on_user_id"
  end

  create_table "perfils", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_perfils_on_discarded_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_permissions_on_discarded_at"
  end

  create_table "proposta", force: :cascade do |t|
    t.string "numero"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reuniaos", force: :cascade do |t|
    t.string "titulo"
    t.text "descricao"
    t.datetime "data"
    t.string "local"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reuniaos_on_user_id"
  end

  create_table "reunioes", force: :cascade do |t|
    t.string "titulo"
    t.datetime "data"
    t.text "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "phone"
    t.string "string"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "cpf"
    t.string "last_known_ip"
    t.string "location"
    t.float "latitude"
    t.float "longitude"
    t.bigint "perfil_id", null: false
    t.datetime "discarded_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["perfil_id"], name: "index_users_on_perfil_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "avisos_users", "avisos"
  add_foreign_key "avisos_users", "users"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "perfil_permissions", "perfils"
  add_foreign_key "perfil_permissions", "permissions"
  add_foreign_key "perfil_users", "perfils"
  add_foreign_key "perfil_users", "users"
  add_foreign_key "reuniaos", "users"
  add_foreign_key "users", "perfils"
end
