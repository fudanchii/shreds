class FeedRemoveCategoryId < ActiveRecord::Migration
  def change
    remove_index :feeds, column: [:category_id, :id]
    remove_column :feeds, :category_id
  end
end
