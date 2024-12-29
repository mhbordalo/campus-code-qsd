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

ActiveRecord::Schema[7.0].define(version: 2023_03_10_193855) do
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

  create_table "blocklisted_customers", force: :cascade do |t|
    t.string "doc_ident", null: false
    t.string "blocklisted_reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doc_ident"], name: "index_blocklisted_customers_on_doc_ident", unique: true
  end

  create_table "bonus_commissions", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.decimal "commission_perc", precision: 8, scale: 2
    t.decimal "amount_limit", precision: 8, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2, null: false
    t.decimal "discount", precision: 8, scale: 2, default: "0.0"
    t.string "payment_mode"
    t.integer "status", default: 0
    t.string "cancel_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "salesman_id"
    t.string "order_code"
    t.string "product_plan_name", null: false
    t.string "product_plan_periodicity", null: false
    t.string "customer_doc_ident", null: false
    t.datetime "paid_at"
    t.integer "product_group_id", null: false
    t.string "product_group_name", null: false
    t.integer "product_plan_id", null: false
    t.integer "product_plan_periodicity_id", null: false
    t.string "coupon_code"
    t.index ["salesman_id"], name: "index_orders_on_salesman_id"
  end

  create_table "paid_commissions", force: :cascade do |t|
    t.datetime "paid_at", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.integer "bonus_commission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "salesman_id"
    t.integer "order_id", null: false
    t.index ["bonus_commission_id"], name: "index_paid_commissions_on_bonus_commission_id"
    t.index ["order_id"], name: "index_paid_commissions_on_order_id"
    t.index ["salesman_id"], name: "index_paid_commissions_on_salesman_id"
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
    t.boolean "admin", default: false
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "orders", "users", column: "salesman_id"
  add_foreign_key "paid_commissions", "bonus_commissions"
  add_foreign_key "paid_commissions", "orders"
  add_foreign_key "paid_commissions", "users", column: "salesman_id"
end
