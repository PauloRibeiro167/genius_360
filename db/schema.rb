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

ActiveRecord::Schema[8.0].define(version: 2025_02_17_190000) do
  create_table "action_permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_action_permissions_on_discarded_at"
  end

  create_table "controller_permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_controller_permissions_on_discarded_at"
  end

  create_table "create_perfil_permissions", force: :cascade do |t|
    t.integer "perfil_id", null: false
    t.integer "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_create_perfil_permissions_on_discarded_at"
    t.index ["perfil_id"], name: "index_create_perfil_permissions_on_perfil_id"
    t.index ["permission_id"], name: "index_create_perfil_permissions_on_permission_id"
  end

  create_table "perfil_permissions", force: :cascade do |t|
    t.integer "perfil_id", null: false
    t.integer "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id", "permission_id"], name: "index_perfil_permissions_on_perfil_id_and_permission_id", unique: true
    t.index ["perfil_id"], name: "index_perfil_permissions_on_perfil_id"
    t.index ["permission_id"], name: "index_perfil_permissions_on_permission_id"
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

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.integer "perfil_id", null: false
    t.datetime "discarded_at"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["perfil_id"], name: "index_users_on_perfil_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "create_perfil_permissions", "perfils"
  add_foreign_key "create_perfil_permissions", "permissions"
  add_foreign_key "perfil_permissions", "perfils"
  add_foreign_key "perfil_permissions", "permissions"
  add_foreign_key "users", "perfils"
end
