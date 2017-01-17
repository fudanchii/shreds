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

ActiveRecord::Schema.define(version: 20170117182301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.text     "permalink"
    t.text     "content"
    t.text     "author"
    t.text     "title"
    t.datetime "published",  default: -> { "now()" }, null: false
    t.text     "summary"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "feed_id"
    t.index ["feed_id"], name: "index_articles_on_feed_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "newsitem_id"
    t.boolean  "unread",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id"
    t.index ["article_id"], name: "index_entries_on_article_id", using: :btree
    t.index ["newsitem_id", "subscription_id"], name: "index_entries_on_newsitem_id_and_subscription_id", unique: true, using: :btree
    t.index ["unread"], name: "index_entries_on_unread", where: "unread", using: :btree
  end

  create_table "feeds", force: :cascade do |t|
    t.text     "url",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "feed_url"
    t.text     "title",       default: "( Untitled )", null: false
    t.string   "etag"
    t.string   "last_status"
    t.datetime "latest_at",   default: -> { "now()" }, null: false
    t.index ["feed_url"], name: "index_feeds_on_feed_url", unique: true, using: :btree
    t.index ["id", "latest_at"], name: "index_feeds_on_id_and_latest_at", using: :btree
  end

  create_table "feeds_subscriptions", id: false, force: :cascade do |t|
    t.integer "feed_id"
    t.integer "subscription_id"
    t.index ["feed_id"], name: "index_feeds_subscriptions_on_feed_id", using: :btree
    t.index ["subscription_id"], name: "index_feeds_subscriptions_on_subscription_id", using: :btree
  end

  create_table "itemhashes", force: :cascade do |t|
    t.string   "urlhash",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["urlhash"], name: "index_itemhashes_on_urlhash", using: :btree
  end

  create_table "newsitems", force: :cascade do |t|
    t.text     "permalink"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.text     "author"
    t.text     "title"
    t.datetime "published",  default: -> { "now()" }, null: false
    t.text     "summary"
    t.index ["feed_id", "id"], name: "index_newsitems_on_feed_id_and_id", unique: true, using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["feed_id", "category_id", "user_id"], name: "index_subscriptions_on_feed_id_and_category_id_and_user_id", unique: true, using: :btree
    t.index ["feed_id", "user_id"], name: "index_subscriptions_on_feed_id_and_user_id", unique: true, using: :btree
    t.index ["user_id", "id"], name: "index_subscriptions_on_user_id_and_id", unique: true, using: :btree
  end

  create_table "urls", force: :cascade do |t|
    t.text     "url"
    t.integer  "feed_id"
    t.integer  "subscription_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["feed_id", "id"], name: "index_urls_on_feed_id_and_id", unique: true, using: :btree
    t.index ["subscription_id", "id"], name: "index_urls_on_subscription_id_and_id", unique: true, using: :btree
    t.index ["url", "feed_id"], name: "index_urls_on_url_and_feed_id", unique: true, using: :btree
    t.index ["url", "subscription_id"], name: "index_urls_on_url_and_subscription_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["token"], name: "index_users_on_token", unique: true, using: :btree
  end

  add_foreign_key "articles", "feeds"
  add_foreign_key "entries", "articles"
  add_foreign_key "urls", "feeds"
  add_foreign_key "urls", "subscriptions"
end
