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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130409134445) do

  create_table "church_managerships", :force => true do |t|
    t.integer  "church_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "church_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "church_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "church_profiles", :force => true do |t|
    t.text     "bio"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.integer  "church_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "churches", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "subdomain"
    t.string   "name"
  end

  add_index "churches", ["subdomain"], :name => "index_churches_on_subdomain", :unique => true

  create_table "prayers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "request_id"
    t.string   "ip_address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reported_contents", :force => true do |t|
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.integer  "owner_id"
    t.string   "reason"
    t.integer  "priority"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "ip_address"
  end

  create_table "requests", :force => true do |t|
    t.string   "text",       :limit => 10000
    t.integer  "user_id"
    t.integer  "church_id"
    t.string   "visibility"
    t.boolean  "anonymous"
    t.string   "ip_address"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "state"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                     :default => "", :null => false
    t.string   "facebook_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "facebook_token_expires_at"
    t.string   "encrypted_password",        :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "provider_uid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "vip_signups", :force => true do |t|
    t.string   "code"
    t.string   "rep_uid"
    t.string   "name"
    t.string   "subdomain"
    t.string   "bio",        :limit => 10000
    t.string   "address"
    t.string   "phone"
    t.string   "website"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "state"
  end

  add_index "vip_signups", ["code"], :name => "index_vip_signups_on_code", :unique => true

end
