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

ActiveRecord::Schema.define(version: 2021_02_05_195527) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adverts", force: :cascade do |t|
    t.string "advert_code"
    t.bigint "user_id"
    t.string "title"
    t.string "pic_url"
    t.string "description"
    t.datetime "time_slot", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_adverts_on_user_id"
  end

  create_table "adverts_ref", force: :cascade do |t|
    t.bigint "source_ad_id"
    t.bigint "linked_ad_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["linked_ad_id"], name: "index_adverts_ref_on_linked_ad_id"
    t.index ["source_ad_id"], name: "index_adverts_ref_on_source_ad_id"
  end

  create_table "black_lists", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.bigint "user_id"
    t.bigint "advert_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["advert_id"], name: "index_comments_on_advert_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "phone"
    t.string "login"
    t.string "password"
    t.string "jwt_token"
    t.datetime "registration_date"
    t.string "city"
    t.datetime "birth_date"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
  end

  add_foreign_key "adverts", "users"
  add_foreign_key "adverts_ref", "adverts", column: "linked_ad_id"
  add_foreign_key "adverts_ref", "adverts", column: "source_ad_id"
  add_foreign_key "comments", "adverts"
  add_foreign_key "comments", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
