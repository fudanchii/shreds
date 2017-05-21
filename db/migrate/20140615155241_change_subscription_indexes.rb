class ChangeSubscriptionIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :subscriptions, [:feed_id, :user_id], :unique => true
  end
end
