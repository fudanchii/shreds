class ChangeFeedIndexColumn < ActiveRecord::Migration
  def change
    remove_index :feeds, :column => [:url]
    add_index :feeds, :feed_url, :unique => true, :length => 1024
  end
end
