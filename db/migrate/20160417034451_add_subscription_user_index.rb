class AddSubscriptionUserIndex < ActiveRecord::Migration
  def change
    add_index :subscriptions, [:user_id, :id], unique: true
  end
end
