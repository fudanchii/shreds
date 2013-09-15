class AddFeedUrl < ActiveRecord::Migration
  def change
    add_column :feeds, :feed_url, :text
  end
end
