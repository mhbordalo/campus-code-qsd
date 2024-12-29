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

ActiveRecord::Schema[7.0].define(version: 2023_03_07_031732) do
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

  create_table "call_categories", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_call_categories_on_description", unique: true
  end

  create_table "call_messages", force: :cascade do |t|
    t.integer "call_id", null: false
    t.integer "user_id", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_id"], name: "index_call_messages_on_call_id"
    t.index ["user_id"], name: "index_call_messages_on_user_id"
  end

  create_table "calls", force: :cascade do |t|
    t.string "call_code"
    t.string "description"
    t.integer "status", default: 0
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.integer "call_category_id", null: false
    t.boolean "resolved"
    t.integer "product_id", null: false
    t.index ["call_category_id"], name: "index_calls_on_call_category_id"
    t.index ["call_code"], name: "index_calls_on_call_code", unique: true
    t.index ["product_id"], name: "index_calls_on_product_id"
    t.index ["user_id"], name: "index_calls_on_user_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "token"
    t.string "card_number"
    t.string "owner_name"
    t.string "credit_card_flag"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.float "price"
    t.date "purchase_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_code"
    t.integer "salesman_id"
    t.string "product_plan_name"
    t.string "product_plan_periodicity"
    t.integer "discount"
    t.string "payment_mode"
    t.string "cancel_reason"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "user_id", null: false
    t.float "price"
    t.date "purchase_date"
    t.integer "status", default: 0
    t.string "order_code"
    t.string "salesman"
    t.string "product_plan_name"
    t.string "product_plan_periodicity"
    t.integer "discount"
    t.string "payment_mode"
    t.text "cancel_reason"
    t.string "installation_code"
    t.string "server_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "installation", default: 0
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identification"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "phone_number"
    t.date "birthdate"
    t.string "name"
    t.string "corporate_name"
    t.integer "status", default: 0
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["identification"], name: "index_users_on_identification", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "call_messages", "calls"
  add_foreign_key "call_messages", "users"
  add_foreign_key "calls", "call_categories"
  add_foreign_key "calls", "products"
  add_foreign_key "calls", "users"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "users"
end
