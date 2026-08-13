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

ActiveRecord::Schema[8.0].define(version: 2026_08_13_140000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "dish_tags", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id", "tag_id"], name: "index_dish_tags_on_dish_id_and_tag_id", unique: true
    t.index ["dish_id"], name: "index_dish_tags_on_dish_id"
    t.index ["tag_id"], name: "index_dish_tags_on_tag_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "image_url"
    t.string "recipe_url"
    t.integer "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "dish_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_favorites_on_dish_id"
    t.index ["user_id", "dish_id"], name: "index_favorites_on_user_id_and_dish_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "histories", force: :cascade do |t|
    t.bigint "dish_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "course_label"
    t.integer "question_count"
    t.json "collected_tags", default: []
    t.json "recommendations", default: {}
    t.bigint "user_id"
    t.index ["dish_id"], name: "index_histories_on_dish_id"
    t.index ["user_id", "created_at"], name: "index_histories_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "dish_tags", "dishes"
  add_foreign_key "dish_tags", "tags"
  add_foreign_key "favorites", "dishes"
  add_foreign_key "favorites", "users"
  add_foreign_key "histories", "dishes"
  add_foreign_key "histories", "users"
  add_foreign_key "sessions", "users"
end
