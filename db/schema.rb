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

ActiveRecord::Schema.define(version: 20160221182443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "account_users", force: true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.text     "permissions"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "account_users", ["account_id"], name: "index_account_users_on_account_id", using: :btree
  add_index "account_users", ["user_id"], name: "index_account_users_on_user_id", using: :btree

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "company_name"
    t.string   "company_website"
    t.string   "company_phone"
    t.string   "company_address_street"
    t.string   "company_address_city"
    t.string   "company_address_state"
    t.string   "company_address_zip"
    t.string   "billing_name"
    t.string   "billing_email"
    t.string   "billing_phone_home"
    t.string   "billing_phone_work"
    t.string   "billing_phone_mobile"
    t.string   "billing_address_street"
    t.string   "billing_address_city"
    t.string   "billing_address_state"
    t.string   "billing_address_zip"
    t.integer  "permissions"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "credits", force: true do |t|
    t.string   "area"
    t.string   "department"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "invoices", force: true do |t|
    t.integer  "account_id"
    t.string   "category"
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.date     "bill_date"
    t.date     "payment_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "invoices", ["account_id"], name: "index_invoices_on_account_id", using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "name_first"
    t.string   "name_middle"
    t.string   "name_last"
    t.string   "phone_home"
    t.string   "phone_work"
    t.string   "phone_mobile"
    t.text     "address_street"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip"
    t.string   "company_name"
    t.text     "company_website"
    t.string   "job_title"
    t.text     "job_description"
    t.text     "profile_description"
    t.boolean  "staff_member"
    t.hstore   "contact_links"
    t.hstore   "image_links"
    t.hstore   "privacy_settings"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "profiles", ["contact_links"], name: "profiles_gin_contact_links", using: :gin
  add_index "profiles", ["image_links"], name: "profiles_gin_image_links", using: :gin
  add_index "profiles", ["privacy_settings"], name: "profiles_gin_privacy_settings", using: :gin
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "project_credits", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_video_id"
    t.integer  "credit_id"
    t.text     "notes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "project_credits", ["credit_id"], name: "index_project_credits_on_credit_id", using: :btree
  add_index "project_credits", ["project_video_id"], name: "index_project_credits_on_project_video_id", using: :btree
  add_index "project_credits", ["user_id"], name: "index_project_credits_on_user_id", using: :btree

  create_table "project_documents", force: true do |t|
    t.integer  "project_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "project_documents", ["project_id"], name: "index_project_documents_on_project_id", using: :btree

  create_table "project_photos", force: true do |t|
    t.integer  "project_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "captured_filename"
  end

  add_index "project_photos", ["project_id"], name: "index_project_photos_on_project_id", using: :btree

  create_table "project_users", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "permissions"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_users", ["project_id"], name: "index_project_users_on_project_id", using: :btree
  add_index "project_users", ["user_id"], name: "index_project_users_on_user_id", using: :btree

  create_table "project_videos", force: true do |t|
    t.integer  "project_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "video_type"
    t.string   "title"
    t.text     "description"
    t.integer  "duration"
  end

  add_index "project_videos", ["project_id"], name: "index_project_videos_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "account_id"
    t.integer  "invoice_id"
    t.string   "category"
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.date     "start"
    t.date     "end"
    t.integer  "client_contact_id"
    t.integer  "internal_contact_id"
    t.integer  "permissions"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.hstore   "image_links"
  end

  add_index "projects", ["account_id"], name: "index_projects_on_account_id", using: :btree
  add_index "projects", ["invoice_id"], name: "index_projects_on_invoice_id", using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "project_id"
    t.integer  "staff_id"
    t.string   "category"
    t.string   "task_type"
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.decimal  "hours_estimate"
    t.decimal  "hours_actual"
    t.decimal  "rate_estimate"
    t.decimal  "rate_actual"
    t.decimal  "staff_rate_estimate"
    t.decimal  "staff_rate_actual"
    t.date     "start"
    t.date     "end"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "user_credits", force: true do |t|
    t.integer  "user_id"
    t.integer  "user_video_id"
    t.integer  "credit_id"
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_credits", ["credit_id"], name: "index_user_credits_on_credit_id", using: :btree
  add_index "user_credits", ["user_id"], name: "index_user_credits_on_user_id", using: :btree
  add_index "user_credits", ["user_video_id"], name: "index_user_credits_on_user_video_id", using: :btree

  create_table "user_documents", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "user_documents", ["user_id"], name: "index_user_documents_on_user_id", using: :btree

  create_table "user_photos", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "user_photos", ["user_id"], name: "index_user_photos_on_user_id", using: :btree

  create_table "user_videos", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "video_type"
    t.string   "title"
    t.text     "description"
    t.integer  "duration"
  end

  add_index "user_videos", ["user_id"], name: "index_user_videos_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
