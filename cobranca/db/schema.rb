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

ActiveRecord::Schema[7.0].define(version: 2023_03_12_152913) do
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

  create_table "charges", force: :cascade do |t|
    t.integer "charge_status", default: 1
    t.string "approve_transaction_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "client_cpf"
    t.string "order"
    t.decimal "final_value"
    t.integer "reasons_id"
    t.string "creditcard_token"
    t.index ["reasons_id"], name: "index_charges_on_reasons_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.integer "promotion_id", null: false
    t.integer "status"
    t.date "consumption_date"
    t.string "consumption_application"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_code"
    t.index ["promotion_id"], name: "index_coupons_on_promotion_id"
  end

  create_table "credit_card_flags", force: :cascade do |t|
    t.string "name"
    t.integer "rate"
    t.integer "maximum_value"
    t.integer "maximum_number_of_installments"
    t.boolean "cash_purchase_discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "card_number"
    t.string "validate_month"
    t.string "validate_year"
    t.string "cvv"
    t.string "owner_name"
    t.string "owner_doc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "alias"
    t.integer "credit_card_flag_id"
    t.index ["card_number"], name: "index_credit_cards_on_card_number", unique: true
    t.index ["credit_card_flag_id"], name: "index_credit_cards_on_credit_card_flag_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.date "start"
    t.date "finish"
    t.integer "discount"
    t.decimal "maximum_discount_value"
    t.integer "coupon_quantity"
    t.integer "status"
    t.date "approve_date"
    t.date "approval_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_create"
    t.integer "user_aprove"
    t.text "products"
  end

  create_table "reasons", force: :cascade do |t|
    t.integer "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "coupons", "promotions"
  add_foreign_key "credit_cards", "credit_card_flags"
end
