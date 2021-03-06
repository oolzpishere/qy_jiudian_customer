# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_21_105419) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "conferences", force: :cascade do |t|
    t.string "name"
    t.date "start"
    t.date "finish"
    t.date "sale_from"
    t.date "sale_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conferences_hotels", id: false, force: :cascade do |t|
    t.integer "conference_id", null: false
    t.integer "hotel_id", null: false
  end

  create_table "date_rooms", force: :cascade do |t|
    t.integer "hotel_room_type_id"
    t.date "date"
    t.integer "rooms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_room_type_id"], name: "index_date_rooms_on_hotel_room_type_id"
  end

  create_table "hotel_images", force: :cascade do |t|
    t.integer "hotel_id"
    t.integer "cover"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_hotel_images_on_hotel_id"
  end

  create_table "hotel_room_types", force: :cascade do |t|
    t.integer "hotel_id"
    t.integer "room_type_id"
    t.decimal "price"
    t.decimal "settlement_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_hotel_room_types_on_hotel_id"
    t.index ["room_type_id"], name: "index_hotel_room_types_on_room_type_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name", null: false
    t.integer "breakfast", default: 0
    t.integer "car", default: 0
    t.decimal "tax_rate", default: "0.0"
    t.decimal "tax_point", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.string "distance"
    t.string "address"
  end

  create_table "identifies", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "unionid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unionid"], name: "index_identifies_on_unionid", unique: true
    t.index ["user_id"], name: "index_identifies_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "group"
    t.integer "count"
    t.integer "conference_id"
    t.integer "hotel_id"
    t.string "room_type"
    t.string "names"
    t.string "contact"
    t.string "phone"
    t.decimal "price"
    t.integer "breakfast"
    t.date "checkin"
    t.date "checkout"
    t.integer "nights"
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["conference_id"], name: "index_orders_on_conference_id"
    t.index ["hotel_id"], name: "index_orders_on_hotel_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "room_types", force: :cascade do |t|
    t.string "name"
    t.string "name_eng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "order_id"
    t.string "names"
    t.string "room_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_rooms_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "username"
    t.string "avatar"
    t.string "motto"
    t.string "otp_secret_key"
    t.integer "otp_counter"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wx_payments", force: :cascade do |t|
    t.integer "payment_id"
    t.string "appid"
    t.string "mch_id"
    t.string "device_info"
    t.string "openid"
    t.string "is_subscribe"
    t.string "trade_type"
    t.string "bank_type"
    t.integer "total_fee"
    t.integer "settlement_total_fee"
    t.string "fee_type"
    t.integer "cash_fee"
    t.string "cash_fee_type"
    t.string "transaction_id"
    t.string "out_trade_no"
    t.string "attach"
    t.date "time_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["out_trade_no"], name: "index_wx_payments_on_out_trade_no"
    t.index ["payment_id"], name: "index_wx_payments_on_payment_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
