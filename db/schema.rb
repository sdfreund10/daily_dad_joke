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

ActiveRecord::Schema.define(version: 20180710225349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jokes", force: :cascade do |t|
    t.string "api_id", null: false
    t.string "joke"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_id"], name: "index_jokes_on_api_id", unique: true
  end

  create_table "user_joke_histories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "joke_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["joke_id"], name: "index_user_joke_histories_on_joke_id"
    t.index ["user_id", "joke_id"], name: "index_user_joke_histories_on_user_id_and_joke_id", unique: true
    t.index ["user_id"], name: "index_user_joke_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time", default: "9:00", null: false
    t.boolean "sunday", default: true, null: false
    t.boolean "monday", default: true, null: false
    t.boolean "tuesday", default: true, null: false
    t.boolean "wednesday", default: true, null: false
    t.boolean "thursday", default: true, null: false
    t.boolean "friday", default: true, null: false
    t.boolean "saturday", default: true, null: false
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

end
