# frozen_string_literal: true

class Category < ActiveRecord::Base
  has_many :subscriptions
  has_many :feeds, through: :subscriptions, source: 'feed'
  has_many :users, through: :subscriptions

  accepts_nested_attributes_for :subscriptions

  scope(:for_nav, -> { order('name ASC') })

  validates :name, presence: true

  before_create { self.name = name.strip.titleize }

  def self.default
    'uncategorized'
  end

  def self.safe_create(cname)
    cname ||= default
    find_or_create_by! name: cname.titleize
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotUnique
    find_by! name: cname.titleize
  end

  def custom_and_unused?
    feeds.count.zero? && name != self.class.default
  end

  def unread_count
    feeds.with_unread_count.reduce(0) { |a, e| a + e.unreads }
  end

  def safe_destroy
    defcat = Category.find_by(name: self.class.default)
    Subscription.transaction do
      subscriptions.each { |s| s.update(category: defcat) }
      destroy
    end
  end
end

# == Schema Information
# Schema version: 20170204045805
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
