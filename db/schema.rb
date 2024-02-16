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

ActiveRecord::Schema[7.1].define(version: 2024_02_12_191313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "api_key", null: false
    t.integer "language", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_clients_on_api_key", unique: true
  end

  create_table "geolocations", force: :cascade do |t|
    t.string "ip", null: false
    t.string "search_value", null: false
    t.string "hostname"
    t.integer "ip_type", null: false
    t.string "continent_code", null: false
    t.string "continent_name", null: false
    t.string "country_code", null: false
    t.string "country_name", null: false
    t.string "region_code", null: false
    t.string "region_name", null: false
    t.string "city", null: false
    t.string "zip", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip"], name: "index_geolocations_on_ip", unique: true
  end

end
