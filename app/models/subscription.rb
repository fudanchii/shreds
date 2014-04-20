class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :feed
  has_many :entries
  has_many :newsitems, :through => :entries
end

# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  feed_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_subscriptions_on_feed_id_and_category_id_and_user_id  (feed_id,category_id,user_id) UNIQUE
#
