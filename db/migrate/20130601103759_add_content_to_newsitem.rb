class AddContentToNewsitem < ActiveRecord::Migration[4.2]
  def change
    add_column :newsitems, :content, :text
  end
end
