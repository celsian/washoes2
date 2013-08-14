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

ActiveRecord::Schema.define(version: 20130811201716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brackets", force: true do |t|
    t.string   "name"
    t.integer  "winner_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brackets", ["user_id"], name: "index_brackets_on_user_id", using: :btree
  add_index "brackets", ["winner_id"], name: "index_brackets_on_winner_id", using: :btree

  create_table "game_players", force: true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "bracket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_players", ["bracket_id"], name: "index_game_players_on_bracket_id", using: :btree
  add_index "game_players", ["game_id"], name: "index_game_players_on_game_id", using: :btree
  add_index "game_players", ["player_id"], name: "index_game_players_on_player_id", using: :btree

  create_table "games", force: true do |t|
    t.integer  "winner_id"
    t.integer  "bracket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "points", force: true do |t|
    t.integer  "score"
    t.integer  "game_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
