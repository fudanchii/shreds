class FeedRemoveCategoryId < ActiveRecord::Migration[4.2]
  def change
    remove_index :feeds, column: [:category_id, :id]
    remove_column :feeds, :category_id
  end
end
