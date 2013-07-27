class ChangeFeedUniqueUrl < ActiveRecord::Migration
  def change
    add_index :feeds, :url, :unique => true, :length => 1024
  end
end
