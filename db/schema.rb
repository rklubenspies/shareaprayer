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

ActiveRecord::Schema.define(:version => 20130213162824) do

  create_table "church_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "church_id"
    t.string   "roles",      :default => "--- []"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "churches", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.string   "text"
    t.integer  "user_id"
    t.integer  "church_id"
    t.string   "visibility"
    t.boolean  "anonymous"
    t.string   "ip_address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "roles",                       :default => "--- []"
    t.integer  "facebook_id",    :limit => 8
    t.string   "facebook_token"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

end
