class AddIndex < ActiveRecord::Migration
  def change
    add_index :feeds, :category_id
    add_index :itemhashes, :urlhash
    add_index :newsitems, :feed_id
  end
end
