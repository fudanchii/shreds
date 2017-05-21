class ChangeNewsitemsIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index :newsitems, :feed_id
    add_index :newsitems, [:feed_id, :id], :unique => true
    remove_index :feeds, :category_id
    add_index :feeds, [:category_id, :id], :unique => true
  end
end
