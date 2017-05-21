class AddSubscriptionUserIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :subscriptions, [:user_id, :id], unique: true
  end
end
