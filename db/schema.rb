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

ActiveRecord::Schema.define(version: 20170622032633) do

  create_table "attendees", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "parent_profile_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["parent_profile_id"], name: "index_attendees_on_parent_profile_id"
    t.index ["student_id"], name: "index_attendees_on_student_id"
  end

  create_table "attendees_events", id: false, force: :cascade do |t|
    t.integer "event_id",    null: false
    t.integer "attendee_id", null: false
    t.index ["attendee_id", "event_id"], name: "index_attendees_events_on_attendee_id_and_event_id"
    t.index ["event_id", "attendee_id"], name: "index_attendees_events_on_event_id_and_attendee_id"
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
    t.index ["parent_id"], name: "index_contact_infos_on_parent_id"
  end

  create_table "event_groups", force: :cascade do |t|
    t.string   "name"
    t.time     "when"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "event_group_id"
    t.date     "when",           default: '2017-06-20'
    t.time     "time",           default: '2000-01-01 01:41:57'
    t.index ["event_group_id"], name: "index_events_on_event_group_id"
  end

  create_table "parent_profiles", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "primary_contact_id"
    t.integer  "energency_contact_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["energency_contact_id"], name: "index_parent_profiles_on_energency_contact_id"
    t.index ["parent_id"], name: "index_parent_profiles_on_parent_id"
    t.index ["primary_contact_id"], name: "index_parent_profiles_on_primary_contact_id"
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
    t.index ["email"], name: "index_parents_on_email", unique: true
    t.index ["parent_profile_id"], name: "index_parents_on_parent_profile_id"
    t.index ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true
  end

  create_table "semesters", force: :cascade do |t|
    t.string   "name"
    t.date     "start"
    t.date     "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.integer  "contact_info_id"
    t.string   "accommodations"
    t.integer  "parent_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["contact_info_id"], name: "index_students_on_contact_info_id"
    t.index ["parent_id"], name: "index_students_on_parent_id"
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
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  create_table "widgeteers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
