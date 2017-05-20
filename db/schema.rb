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

ActiveRecord::Schema.define(version: 20170519183037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_index "addresses", ["property_id"], name: "index_addresses_on_property_id", using: :btree

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

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "agent_forms", force: :cascade do |t|
    t.string   "first_name"
    t.string   "email"
    t.string   "company_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "last_name"
  end

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
    t.string   "company_name"
    t.string   "profile_picture"
  end

  add_index "agents", ["email"], name: "index_agents_on_email", unique: true, using: :btree
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true, using: :btree

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
    t.string   "sub_type"
    t.integer  "timeframe"
  end

  add_index "contact_forms", ["property_id"], name: "index_contact_forms_on_property_id", using: :btree

  create_table "features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "property_id"
    t.string   "picture"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "photos", ["property_id"], name: "index_photos_on_property_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
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
    t.integer  "list_price_cents",   limit: 8
    t.integer  "stories"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "fireplaces"
    t.decimal  "lot_length",                   precision: 6, scale: 2
    t.decimal  "lot_width",                    precision: 6, scale: 2
    t.text     "description"
    t.integer  "status_id",                                            default: 1
    t.string   "matterurl"
    t.json     "pictures"
    t.boolean  "sold",                                                 default: false
    t.string   "featured_photo"
    t.integer  "agent_id"
    t.text     "note"
  end

  add_index "properties", ["agent_id"], name: "index_properties_on_agent_id", using: :btree
  add_index "properties", ["status_id"], name: "index_properties_on_status_id", using: :btree

  create_table "property_upgrades", force: :cascade do |t|
    t.integer "property_id"
    t.integer "upgrade_id"
  end

  add_index "property_upgrades", ["property_id"], name: "index_property_upgrades_on_property_id", using: :btree
  add_index "property_upgrades", ["upgrade_id"], name: "index_property_upgrades_on_upgrade_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.string   "name"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "full_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upgrades", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "addresses", "properties"
  add_foreign_key "contact_forms", "properties"
  add_foreign_key "properties", "agents"
  add_foreign_key "properties", "statuses"
  add_foreign_key "property_upgrades", "properties"
  add_foreign_key "property_upgrades", "upgrades"
end
