class RemoveNewsitemUnreadColumn < ActiveRecord::Migration
  def change
    remove_column :newsitems, :unread
  end
end
