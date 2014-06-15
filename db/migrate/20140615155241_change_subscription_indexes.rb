class ChangeSubscriptionIndexes < ActiveRecord::Migration
  def change
    add_index :subscriptions, [:feed_id, :user_id], :unique => true
  end
end
