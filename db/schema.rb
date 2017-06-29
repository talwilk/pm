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

ActiveRecord::Schema.define(version: 20170318224247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", id: false, force: :cascade do |t|
    t.string   "country_iso",    null: false
    t.integer  "super_admin_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "enabled_at"
  end

  add_index "countries", ["country_iso"], name: "index_countries_on_country_iso", using: :btree
  add_index "countries", ["enabled_at"], name: "index_countries_on_enabled_at", using: :btree

  create_table "dilemma_advices", force: :cascade do |t|
    t.text     "content",                     null: false
    t.integer  "dilemma_id",                  null: false
    t.integer  "user_id",                     null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "cached_votes_up", default: 0
  end

  add_index "dilemma_advices", ["cached_votes_up"], name: "index_dilemma_advices_on_cached_votes_up", using: :btree
  add_index "dilemma_advices", ["content"], name: "index_dilemma_advices_on_content", using: :btree
  add_index "dilemma_advices", ["deleted_at"], name: "index_dilemma_advices_on_deleted_at", using: :btree
  add_index "dilemma_advices", ["dilemma_id"], name: "index_dilemma_advices_on_dilemma_id", using: :btree
  add_index "dilemma_advices", ["user_id"], name: "index_dilemma_advices_on_user_id", using: :btree

  create_table "dilemmas", force: :cascade do |t|
    t.string   "title",                                      null: false
    t.string   "description",                                null: false
    t.datetime "ends_at",                                    null: false
    t.boolean  "first_advice_added",         default: false
    t.integer  "user_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "deleted_at"
    t.integer  "cover_photo"
    t.integer  "favorite_dilemma_advice_id"
    t.datetime "favorite_advice_ends_at"
    t.string   "permalink"
    t.string   "short_url"
    t.boolean  "closed_notification_sent",   default: false
    t.boolean  "reward_notification_sent",   default: false
    t.integer  "task_id"
  end

  add_index "dilemmas", ["favorite_advice_ends_at"], name: "index_dilemmas_on_favorite_advice_ends_at", using: :btree
  add_index "dilemmas", ["favorite_dilemma_advice_id"], name: "index_dilemmas_on_favorite_dilemma_advice_id", using: :btree
  add_index "dilemmas", ["task_id"], name: "index_dilemmas_on_task_id", using: :btree
  add_index "dilemmas", ["user_id"], name: "index_dilemmas_on_user_id", using: :btree

  create_table "guru_applications", force: :cascade do |t|
    t.text     "form_hash",         null: false
    t.datetime "review_started_at"
    t.datetime "rejected_at"
    t.datetime "accepted_at"
    t.integer  "user_id",           null: false
    t.inet     "application_ip"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "reviewer_id"
    t.integer  "resulter_id"
    t.text     "super_admin_note"
  end

  add_index "guru_applications", ["resulter_id"], name: "index_guru_applications_on_resulter_id", using: :btree
  add_index "guru_applications", ["reviewer_id"], name: "index_guru_applications_on_reviewer_id", using: :btree
  add_index "guru_applications", ["user_id"], name: "index_guru_applications_on_user_id", using: :btree

  create_table "login_histories", force: :cascade do |t|
    t.inet     "current_sign_in_ip", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "login_method",       null: false
    t.boolean  "successful_login",   null: false
    t.integer  "user_id",            null: false
  end

  add_index "login_histories", ["user_id"], name: "index_login_histories_on_user_id", using: :btree

  create_table "media", force: :cascade do |t|
    t.string   "file"
    t.string   "youtube_url"
    t.string   "image_url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "deleted_at"
    t.integer  "mediable_id"
    t.string   "mediable_type"
    t.text     "media_description"
  end

  add_index "media", ["mediable_type", "mediable_id"], name: "index_media_on_mediable_type_and_mediable_id", using: :btree

  create_table "payment_plan_transactions", force: :cascade do |t|
    t.string   "payment_plan", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "deleted_at"
  end

  add_index "payment_plan_transactions", ["user_id"], name: "index_payment_plan_transactions_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title",       null: false
    t.text     "content",     null: false
    t.string   "cover_image"
    t.integer  "user_id",     null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "address"
    t.date    "orig_start_date"
    t.date    "cur_start_date"
    t.string  "plot"
    t.string  "build"
    t.string  "orig_budget"
    t.string  "cur_budget"
    t.string  "email"
    t.string  "reserve"
    t.integer "type_id"
    t.integer "user_id"
    t.integer "qna_id"
  end

  create_table "pros", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "company_name"
    t.string  "email"
    t.string  "mobile_phone"
    t.string  "phone"
    t.string  "category"
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "qnas", force: :cascade do |t|
    t.string "q1"
    t.string "q2"
    t.string "q3"
    t.string "q4"
  end

  create_table "super_admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "full_name",              default: ""
    t.datetime "deleted_at"
  end

  add_index "super_admins", ["email"], name: "index_super_admins_on_email", unique: true, using: :btree
  add_index "super_admins", ["reset_password_token"], name: "index_super_admins_on_reset_password_token", unique: true, using: :btree
  add_index "super_admins", ["unlock_token"], name: "index_super_admins_on_unlock_token", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "taskindices", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.string  "phase"
    t.string  "description"
    t.string  "recommend"
    t.string  "status"
    t.integer "duration"
    t.integer "cost"
    t.integer "est_duration_min"
    t.integer "est_duration_max"
    t.integer "est_cost_min"
    t.integer "est_cost_max"
    t.string  "category"
    t.string  "predecessor"
    t.string  "ptype"
    t.string  "task_landing_page"
    t.string  "task_tips"
    t.string  "manual_ind"
    t.string  "task_type"
  end

  create_table "tasks", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.string  "phase"
    t.string  "description"
    t.string  "notes"
    t.string  "recommend"
    t.string  "status"
    t.string  "category"
    t.string  "predecessor"
    t.string  "ptype"
    t.string  "manual_ind"
    t.string  "task_type"
    t.string  "task_landing_page"
    t.string  "task_tips"
    t.integer "est_duration_min"
    t.integer "est_duration_max"
    t.integer "est_cost_min"
    t.integer "est_cost_max"
    t.integer "duration"
    t.integer "cost"
    t.integer "paid"
    t.integer "dilemma_count"
    t.string  "dilemma_list"
    t.string  "image_url"
    t.date    "start_date"
    t.date    "cur_start_date"
    t.date    "orig_end_date"
    t.date    "cur_end_date"
    t.integer "project_id"
    t.integer "pro_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
  end

  create_table "user_points_logs", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.integer  "gamificable_id"
    t.string   "gamificable_type"
    t.string   "activity",                               null: false
    t.integer  "points_amount",                          null: false
    t.integer  "super_admin_id"
    t.string   "super_admin_granted_points_description"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "user_points_logs", ["created_at"], name: "index_user_points_logs_on_created_at", using: :btree
  add_index "user_points_logs", ["gamificable_id", "gamificable_type"], name: "index_user_points_logs_on_gamificable_id_and_gamificable_type", using: :btree
  add_index "user_points_logs", ["points_amount"], name: "index_user_points_logs_on_points_amount", using: :btree
  add_index "user_points_logs", ["user_id"], name: "index_user_points_logs_on_user_id", using: :btree

  create_table "user_profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "avatar"
    t.string   "website_link"
    t.string   "facebook_link"
    t.string   "google_plus_link"
    t.string   "twitter_link"
    t.string   "pinterest_link"
    t.string   "instagram_link"
    t.string   "category"
    t.integer  "user_id"
    t.string   "address"
    t.string   "company"
    t.string   "mobile_number"
    t.text     "mantra"
    t.datetime "deleted_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "show_email",         default: true
    t.boolean  "show_mobile_number", default: true
    t.string   "experience"
    t.string   "last_name",          default: ""
    t.string   "locale",             default: "he", null: false
  end

  add_index "user_profiles", ["deleted_at"], name: "index_user_profiles_on_deleted_at", using: :btree
  add_index "user_profiles", ["experience"], name: "index_user_profiles_on_experience", using: :btree
  add_index "user_profiles", ["last_name"], name: "index_user_profiles_on_last_name", using: :btree
  add_index "user_profiles", ["locale"], name: "index_user_profiles_on_locale", using: :btree
  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        default: "",        null: false
    t.string   "encrypted_password",           default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "deleted_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "facebook_oauth_uid"
    t.string   "google_oauth_uid"
    t.string   "reopen_account_token"
    t.datetime "reopen_account_token_sent_at"
    t.datetime "reopened_at"
    t.string   "role",                         default: "regular", null: false
    t.string   "payment_plan"
    t.string   "username",                                         null: false
    t.boolean  "first_dilemma_added",          default: false
    t.string   "signup_way",                   default: "regular", null: false
    t.inet     "registration_ip_address"
    t.string   "country_iso"
    t.text     "additional_geolocation_info"
    t.integer  "total_points",                 default: 0
    t.integer  "level",                        default: 0,         null: false
    t.integer  "best_advice_badge",            default: 0,         null: false
    t.integer  "like_advice_badge",            default: 0,         null: false
    t.integer  "dilemma_advices_badge",        default: 0,         null: false
    t.integer  "following_badge",              default: 0,         null: false
    t.integer  "followed_badge",               default: 0,         null: false
    t.boolean  "first_dilemma_solved",         default: false
  end

  add_index "users", ["best_advice_badge"], name: "index_users_on_best_advice_badge", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["country_iso"], name: "index_users_on_country_iso", using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["dilemma_advices_badge"], name: "index_users_on_dilemma_advices_badge", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["followed_badge"], name: "index_users_on_followed_badge", using: :btree
  add_index "users", ["following_badge"], name: "index_users_on_following_badge", using: :btree
  add_index "users", ["level"], name: "index_users_on_level", using: :btree
  add_index "users", ["like_advice_badge"], name: "index_users_on_like_advice_badge", using: :btree
  add_index "users", ["reopen_account_token"], name: "index_users_on_reopen_account_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["signup_way"], name: "index_users_on_signup_way", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
