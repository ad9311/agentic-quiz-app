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

ActiveRecord::Schema[8.1].define(version: 2025_12_26_180313) do
  create_table "options", force: :cascade do |t|
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "question_id", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "correct"], name: "index_options_on_question_id_and_correct"
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.text "explanation"
    t.integer "quiz_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_quizzes_on_title", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "options", "questions", on_delete: :cascade
  add_foreign_key "questions", "quizzes", on_delete: :cascade
end
