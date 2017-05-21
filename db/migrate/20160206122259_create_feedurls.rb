class CreateFeedurls < ActiveRecord::Migration[4.2]
  def change
    create_table :feedurls do |t|
      t.text :url
      t.string :last_fetch_status
      t.datetime :last_fetch_time
      t.references :feed, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :feedurls, [:url, :feed_id], unique: true
    add_index :feedurls, :last_fetch_status
  end
end
