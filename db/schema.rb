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

ActiveRecord::Schema.define(version: 20170709235817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ballots", force: :cascade do |t|
    t.integer "student_id"
    t.integer "semester_id"
    t.integer "course_id"
    t.string  "preferences", default: "{}"
    t.boolean "exclusive"
    t.index ["course_id"], name: "index_ballots_on_course_id", using: :btree
    t.index ["semester_id"], name: "index_ballots_on_semester_id", using: :btree
    t.index ["student_id"], name: "index_ballots_on_student_id", using: :btree
  end

  create_table "contact_infos", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "email"
    t.string   "phone"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_contact_infos_on_parent_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.integer  "grade"
    t.integer  "semester_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "overview"
    t.index ["semester_id"], name: "index_courses_on_semester_id", using: :btree
  end

  create_table "event_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
    t.integer  "wday"
    t.time     "time"
    t.index ["course_id"], name: "index_event_groups_on_course_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "section_id"
    t.date     "when",       default: '2017-06-30'
    t.time     "time",       default: '2000-01-01 01:24:03'
    t.index ["section_id"], name: "index_events_on_section_id", using: :btree
  end

  create_table "parent_profiles", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "primary_contact_id"
    t.integer  "energency_contact_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["energency_contact_id"], name: "index_parent_profiles_on_energency_contact_id", using: :btree
    t.index ["parent_id"], name: "index_parent_profiles_on_parent_id", using: :btree
    t.index ["primary_contact_id"], name: "index_parent_profiles_on_primary_contact_id", using: :btree
  end

  create_table "parents", force: :cascade do |t|
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
    t.integer  "parent_profile_id"
    t.index ["email"], name: "index_parents_on_email", unique: true, using: :btree
    t.index ["parent_profile_id"], name: "index_parents_on_parent_profile_id", using: :btree
    t.index ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true, using: :btree
  end

  create_table "semesters", force: :cascade do |t|
    t.string   "name"
    t.date     "start"
    t.date     "end"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "state",      default: 0
    t.boolean  "current",    default: false
  end

  create_table "special_events", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.time     "start"
    t.time     "end"
    t.string   "description"
    t.integer  "capacity"
    t.integer  "semester_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["semester_id"], name: "index_special_events_on_semester_id", using: :btree
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.integer  "contact_info_id"
    t.string   "accommodations"
    t.integer  "parent_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "grade"
    t.index ["contact_info_id"], name: "index_students_on_contact_info_id", using: :btree
    t.index ["parent_id"], name: "index_students_on_parent_id", using: :btree
  end

  create_table "teachers", force: :cascade do |t|
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
    t.index ["email"], name: "index_teachers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true, using: :btree
  end

end
