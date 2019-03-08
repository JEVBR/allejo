# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_08_193407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "pitch_id"
    t.bigint "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "player_name"
    t.string "player_phone"
    t.boolean "blocked", default: false
    t.string "match_day_mailer_job_id"
    t.index ["pitch_id"], name: "index_bookings_on_pitch_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
    t.index ["booking_id"], name: "index_participants_on_booking_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "pitches", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.bigint "category_id"
    t.string "subtitle"
    t.string "address"
    t.string "cep"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.float "latitude"
    t.float "longitude"
    t.string "photo"
    t.integer "opening_time"
    t.integer "closing_time"
    t.text "description"
    t.string "phone"
    t.index ["category_id"], name: "index_pitches_on_category_id"
    t.index ["user_id"], name: "index_pitches_on_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "nickname"
    t.string "address"
    t.string "cpf"
    t.boolean "owner", default: false
    t.string "photo"
    t.string "full_name"
    t.boolean "admin", default: false, null: false
    t.float "latitude"
    t.float "longitude"
    t.bigint "position_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["position_id"], name: "index_users_on_position_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "pitches"
  add_foreign_key "bookings", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "participants", "bookings"
  add_foreign_key "participants", "users"
  add_foreign_key "pitches", "categories"
  add_foreign_key "pitches", "users"
  add_foreign_key "users", "positions"
end
