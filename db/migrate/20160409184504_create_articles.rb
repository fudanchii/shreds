class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text     "permalink"
      t.text     "content"
      t.text     "author"
      t.text     "title"
      t.datetime "published",  default: "now()", null: false
      t.text     "summary"
      t.timestamps null: false

      t.references :feed, index: true, foreign_key: true
    end
  end
end
