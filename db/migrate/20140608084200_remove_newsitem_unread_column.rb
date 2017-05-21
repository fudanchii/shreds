class RemoveNewsitemUnreadColumn < ActiveRecord::Migration[4.2]
  def change
    remove_column :newsitems, :unread
  end
end
