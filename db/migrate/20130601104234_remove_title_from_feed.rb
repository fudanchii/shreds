class RemoveTitleFromFeed < ActiveRecord::Migration[4.2]
  def up
    remove_column :feeds, :title
  end

  def down
    add_column :feeds, :title, :string
  end
end
