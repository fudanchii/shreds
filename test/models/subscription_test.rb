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
#  index_subscriptions_on_feed_id_and_user_id                  (feed_id,user_id) UNIQUE
#

require 'test_helper'

describe Subscription do
  before do
    @sub = subscriptions(:subs1)
    @user = @sub.user
    @feed2 = feeds(:feed2)
  end

  it 'can be created by user' do
    @newsub = @user.subscriptions.build(feed: @feed2)
    @newsub.save!
    @user.subscriptions.count.must_equal 2
    @newsub.category.name.must_equal Category.default
  end

  it 'should have unique feed per user' do
    @newsub = @user.subscriptions.build(feed: @feed2)
    @newsub.save!
    lambda do
      @user.subscriptions << Subscription.create(feed: @feed2)
    end.must_raise ActiveRecord::RecordNotUnique
    @user.subscriptions.count.must_equal 2
  end
end
