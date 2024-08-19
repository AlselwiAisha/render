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

ActiveRecord::Schema[7.1].define(version: 2024_07_22_180148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "details_of_works", force: :cascade do |t|
    t.bigint "shop_employee_id", null: false
    t.bigint "product_work_id", null: false
    t.decimal "price"
    t.integer "count", default: 1
    t.integer "percent_done", default: 1
    t.datetime "start_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_work_id"], name: "index_details_of_works_on_product_work_id"
    t.index ["shop_employee_id"], name: "index_details_of_works_on_shop_employee_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_works", force: :cascade do |t|
    t.decimal "percent"
    t.bigint "product_id", null: false
    t.bigint "work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_works_on_product_id"
    t.index ["work_id"], name: "index_product_works_on_work_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "prototype_id", null: false
    t.bigint "shop_id", null: false
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prototype_id"], name: "index_products_on_prototype_id"
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "prototypes", force: :cascade do |t|
    t.string "name"
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_prototypes_on_group_id"
  end

  create_table "shop_employees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_employees_on_shop_id"
    t.index ["user_id"], name: "index_shop_employees_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "location"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "jti", null: false
    t.string "address"
    t.string "phone"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_works_on_shop_id"
  end

  add_foreign_key "details_of_works", "product_works"
  add_foreign_key "details_of_works", "shop_employees"
  add_foreign_key "product_works", "products"
  add_foreign_key "product_works", "works"
  add_foreign_key "products", "prototypes"
  add_foreign_key "products", "shops"
  add_foreign_key "prototypes", "groups"
  add_foreign_key "shop_employees", "shops"
  add_foreign_key "shop_employees", "users"
  add_foreign_key "works", "shops"
end
