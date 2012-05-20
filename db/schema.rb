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

ActiveRecord::Schema.define(:version => 20120519100758) do

  create_table "arguments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "viewpoint_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "is_up_vote",   :default => true
  end

  add_index "arguments", ["user_id"], :name => "index_arguments_on_user_id"
  add_index "arguments", ["viewpoint_id"], :name => "index_arguments_on_viewpoint_id"

  create_table "debate_invites", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "debate_id"
    t.integer  "receiver_id"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "debate_invites", ["debate_id"], :name => "index_debate_invites_on_debate_id"
  add_index "debate_invites", ["email"], :name => "index_debate_invites_on_email"
  add_index "debate_invites", ["sender_id", "debate_id", "email"], :name => "index_debate_invites_on_sender_id_and_debate_id_and_email", :unique => true
  add_index "debate_invites", ["sender_id"], :name => "index_debate_invites_on_sender_id"

  create_table "debates", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "debates", ["user_id", "created_at"], :name => "index_debates_on_user_id_and_created_at"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "confirmation_token"
  end

  add_index "invitations", ["confirmation_token"], :name => "index_invitations_on_confirmation_token"
  add_index "invitations", ["email"], :name => "index_invitations_on_email"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "invites", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.integer  "unknown_object_id"
    t.string   "classname"
    t.string   "confirmation_token"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "invites", ["email"], :name => "index_invites_on_email"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "message"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "classname"
    t.integer  "unknown_object_id"
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",              :default => false
    t.datetime "confirmed_at"
    t.string   "confirmation_token"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "viewpoints", :force => true do |t|
    t.string   "desc"
    t.integer  "debate_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "votes",      :default => 0
    t.integer  "user_id"
    t.boolean  "published",  :default => false
  end

  add_index "viewpoints", ["debate_id"], :name => "index_viewpoints_on_debate_id"
  add_index "viewpoints", ["user_id"], :name => "index_viewpoints_on_user_id"

end
