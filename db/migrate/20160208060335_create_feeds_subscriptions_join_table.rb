class CreateFeedsSubscriptionsJoinTable < ActiveRecord::Migration
  def change
    create_table :feeds_subscriptions, id: false do |t|
      t.belongs_to :feed, index: true
      t.belongs_to :subscription, index: true
    end
  end
end
