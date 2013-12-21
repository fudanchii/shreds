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

ActiveRecord::Schema.define(version: 20131221195859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: true do |t|
    t.text     "url",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.text     "feed_url"
    t.text     "title",       default: "( Untitled )", null: false
    t.string   "etag"
  end

  add_index "feeds", ["category_id", "id"], name: "index_feeds_on_category_id_and_id", unique: true, using: :btree
  add_index "feeds", ["feed_url"], name: "index_feeds_on_feed_url", unique: true, using: :btree

  create_table "itemhashes", force: true do |t|
    t.string   "urlhash",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itemhashes", ["urlhash"], name: "index_itemhashes_on_urlhash", using: :btree

  create_table "newsitems", force: true do |t|
    t.text     "permalink"
    t.boolean  "unread",     default: true
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.text     "author"
    t.text     "title"
    t.datetime "published",  default: "now()", null: false
    t.text     "summary"
  end

  add_index "newsitems", ["feed_id", "id"], name: "index_newsitems_on_feed_id_and_id", unique: true, using: :btree

end
