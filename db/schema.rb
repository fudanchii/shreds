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

ActiveRecord::Schema.define(version: 20170519191311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.text "permalink"
    t.text "content"
    t.text "author"
    t.text "title"
    t.datetime "published", default: -> { "now()" }, null: false
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feed_id"
    t.index ["feed_id"], name: "index_articles_on_feed_id"
    t.index ["published", "feed_id"], name: "index_articles_on_published_and_feed_id", order: { published: :desc }
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "entries", id: :serial, force: :cascade do |t|
    t.integer "subscription_id"
    t.boolean "unread", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "article_id"
    t.index ["article_id"], name: "index_entries_on_article_id"
    t.index ["unread", "article_id", "subscription_id"], name: "index_entries_on_unread_and_article_id_and_subscription_id", order: { unread: :desc }
    t.index ["unread", "article_id"], name: "index_entries_on_unread_and_article_id", order: { unread: :desc }
    t.index ["unread", "subscription_id"], name: "index_entries_on_unread_and_subscription_id", order: { unread: :desc }
  end

  create_table "feeds", id: :serial, force: :cascade do |t|
    t.text "url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "feed_url"
    t.text "title", default: "( Untitled )", null: false
    t.string "etag"
    t.string "last_status"
    t.index ["feed_url"], name: "index_feeds_on_feed_url", unique: true
  end

  create_table "feeds_subscriptions", id: false, force: :cascade do |t|
    t.integer "feed_id"
    t.integer "subscription_id"
    t.index ["feed_id"], name: "index_feeds_subscriptions_on_feed_id"
    t.index ["subscription_id"], name: "index_feeds_subscriptions_on_subscription_id"
  end

  create_table "itemhashes", id: :serial, force: :cascade do |t|
    t.string "urlhash", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["urlhash"], name: "index_itemhashes_on_urlhash"
  end

  create_table "newsitems", id: :serial, force: :cascade do |t|
    t.text "permalink"
    t.integer "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content"
    t.text "author"
    t.text "title"
    t.datetime "published", default: -> { "now()" }, null: false
    t.text "summary"
    t.index ["feed_id", "id"], name: "index_newsitems_on_feed_id_and_id", unique: true
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["feed_id", "category_id", "user_id"], name: "index_subscriptions_on_feed_id_and_category_id_and_user_id", unique: true
    t.index ["feed_id", "user_id"], name: "index_subscriptions_on_feed_id_and_user_id", unique: true
    t.index ["user_id", "id"], name: "index_subscriptions_on_user_id_and_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "uid"
    t.string "provider"
    t.string "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "articles", "feeds"
  add_foreign_key "entries", "articles"
end
