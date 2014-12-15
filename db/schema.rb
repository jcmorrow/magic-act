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

ActiveRecord::Schema.define(version: 20141215185106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "approved",               default: false, null: false
  end

  add_index "admins", ["approved"], name: "index_admins_on_approved", using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "field_rules", force: true do |t|
    t.string   "extract_field"
    t.text     "transformation"
    t.string   "load_field"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "object_rule_id"
    t.boolean  "is_primary"
    t.boolean  "is_foreign_key"
  end

  create_table "job_object_rels", force: true do |t|
    t.integer  "job_id"
    t.integer  "object_rule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_schedules", force: true do |t|
    t.integer  "interval_length"
    t.string   "interval_unit"
    t.time     "run_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "jobs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "query"
    t.integer  "extract_count"
    t.integer  "transform_count"
    t.integer  "load_count"
    t.float    "duration"
    t.integer  "new_load_objects"
    t.integer  "errors_count"
    t.integer  "job_schedule_id"
    t.string   "name"
  end

  create_table "object_rules", force: true do |t|
    t.string   "load_object"
    t.string   "extract_object"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_primary"
    t.text     "custom_from_clause"
    t.string   "name"
  end

  create_table "sub_job_groups", force: true do |t|
    t.integer  "job_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_jobs", force: true do |t|
    t.integer  "job_id"
    t.integer  "object_rule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extract_file_file_name"
    t.string   "extract_file_content_type"
    t.integer  "extract_file_file_size"
    t.datetime "extract_file_updated_at"
    t.integer  "extract_count"
    t.string   "transform_file_file_name"
    t.string   "transform_file_content_type"
    t.integer  "transform_file_file_size"
    t.datetime "transform_file_updated_at"
    t.integer  "transform_count"
    t.string   "load_file_file_name"
    t.string   "load_file_content_type"
    t.integer  "load_file_file_size"
    t.datetime "load_file_updated_at"
    t.integer  "load_count"
    t.integer  "new_load_objects"
    t.integer  "errors_count"
    t.string   "load_job_id"
    t.float    "duration"
    t.text     "query"
    t.integer  "sub_job_group_id"
  end

end
