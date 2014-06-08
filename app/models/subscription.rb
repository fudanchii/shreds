class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :feed
  has_many :entries, :dependent => :destroy
  has_many :newsitems, :through => :entries

  before_save :ensure_category

  def unreads
    entries.where(:unread => true).count
  end

  private

  def ensure_category
    self.category_id = Category.where(:name => Category.default).first.id unless self.category_id
  end
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
