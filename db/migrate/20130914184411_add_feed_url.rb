class AddFeedUrl < ActiveRecord::Migration[4.2]
  def change
    add_column :feeds, :feed_url, :text
  end
end
