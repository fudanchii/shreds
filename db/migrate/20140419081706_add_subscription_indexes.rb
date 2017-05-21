class AddSubscriptionIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :subscriptions, [:feed_id, :category_id, :user_id], :unique => true
    add_index :entries, [:newsitem_id, :subscription_id], :unique => true
    add_index :entries, :unread, :where => 'unread'
  end
end
