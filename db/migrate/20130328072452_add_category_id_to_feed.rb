class AddCategoryIdToFeed < ActiveRecord::Migration[4.2]
  def change
    add_column :feeds, :category_id, :integer
  end
end
