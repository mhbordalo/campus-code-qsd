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

ActiveRecord::Schema[7.0].define(version: 2023_03_06_081355) do
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

  create_table "install_products", force: :cascade do |t|
    t.string "customer_document"
    t.string "order_code"
    t.integer "server_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.index ["server_id"], name: "index_install_products_on_server_id"
  end

  create_table "periodicities", force: :cascade do |t|
    t.string "name"
    t.integer "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_periodicities_on_name", unique: true
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "product_group_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "details"
    t.index ["product_group_id"], name: "index_plans_on_product_group_id"
  end

  create_table "prices", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2
    t.integer "status", default: 0
    t.integer "periodicity_id", null: false
    t.integer "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["periodicity_id"], name: "index_prices_on_periodicity_id"
    t.index ["plan_id"], name: "index_prices_on_plan_id"
  end

  create_table "product_groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "code"
    t.integer "status", default: 5
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_product_groups_on_code", unique: true
  end

  create_table "servers", force: :cascade do |t|
    t.string "code"
    t.string "os_version"
    t.integer "number_of_cpus"
    t.integer "storage_capacity"
    t.integer "amount_of_ram"
    t.integer "max_installations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_group_id", null: false
    t.integer "operational_system"
    t.integer "type_of_storage"
    t.index ["product_group_id"], name: "index_servers_on_product_group_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "install_products", "servers"
  add_foreign_key "plans", "product_groups"
  add_foreign_key "prices", "periodicities"
  add_foreign_key "prices", "plans"
  add_foreign_key "servers", "product_groups"
end
