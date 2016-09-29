# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160929223318) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address_first"
    t.string   "address_second"
    t.string   "street"
    t.string   "city"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "postal_code"
    t.integer  "property_id"
    t.decimal  "latitude",       precision: 9, scale: 6
    t.decimal  "longitude",      precision: 9, scale: 6
  end

  add_index "addresses", ["property_id"], name: "index_addresses_on_property_id"

  create_table "admins", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "last_name"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true

  create_table "agents", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "agent_id"
  end

  add_index "agents", ["email"], name: "index_agents_on_email", unique: true
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_forms", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "notes"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "property_id"
    t.string   "status"
    t.integer  "timeframe"
  end

  add_index "contact_forms", ["property_id"], name: "index_contact_forms_on_property_id"

  create_table "customers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.text     "address"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "property_id"
    t.integer  "customer_id"
    t.integer  "wishlist_id"
  end

  add_index "favorites", ["customer_id"], name: "index_favorites_on_customer_id"
  add_index "favorites", ["property_id"], name: "index_favorites_on_property_id"

  create_table "features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "property_id"
    t.string   "picture"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "photos", ["property_id"], name: "index_photos_on_property_id"

  create_table "properties", force: :cascade do |t|
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "seller_info"
    t.string   "pid"
    t.string   "dwelling_class"
    t.string   "property_type"
    t.string   "building_type"
    t.string   "title_to_land"
    t.string   "sellers_interest"
    t.string   "architecture_style"
    t.integer  "number_of_floors"
    t.integer  "floor_area"
    t.integer  "year_built"
    t.integer  "list_price_cents",   limit: 9
    t.integer  "stories"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "fireplaces"
    t.decimal  "lot_length",                   precision: 8, scale: 2
    t.decimal  "lot_width",                    precision: 8, scale: 2
    t.string   "status"
    t.text     "description"
    t.boolean  "kitchen_upgrades"
    t.boolean  "bathroom_upgrades"
    t.boolean  "basement_upgrades"
    t.boolean  "pool_upgrades"
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wishlists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
  end

end
