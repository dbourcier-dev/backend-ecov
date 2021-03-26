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

ActiveRecord::Schema.define(version: 2021_03_26_151155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "driver_rides", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "ride_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ride_id"], name: "index_driver_rides_on_ride_id"
    t.index ["user_id"], name: "index_driver_rides_on_user_id"
  end

  create_table "networks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passenger_rides", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "ride_id"
    t.bigint "driver_ride_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_ride_id"], name: "index_passenger_rides_on_driver_ride_id"
    t.index ["ride_id"], name: "index_passenger_rides_on_ride_id"
    t.index ["user_id"], name: "index_passenger_rides_on_user_id"
  end

  create_table "rides", force: :cascade do |t|
    t.string "departure"
    t.string "arrival"
    t.boolean "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "network_id"
    t.index ["network_id"], name: "index_rides_on_network_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "network_id"
    t.index ["network_id"], name: "index_users_on_network_id"
  end

  add_foreign_key "driver_rides", "rides"
  add_foreign_key "driver_rides", "users"
  add_foreign_key "passenger_rides", "driver_rides"
  add_foreign_key "passenger_rides", "rides"
  add_foreign_key "passenger_rides", "users"
end
