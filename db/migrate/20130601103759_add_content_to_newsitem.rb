class AddContentToNewsitem < ActiveRecord::Migration
  def change
    add_column :newsitems, :content, :text
  end
end
