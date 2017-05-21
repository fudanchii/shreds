class ChangeFeedUniqueUrl < ActiveRecord::Migration[4.2]
  def change
    add_index :feeds, :url, :unique => true, :length => 1024
  end
end
