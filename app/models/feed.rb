require 'uri'

class Feed < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :categories, :through => :subscriptions
  has_many :users, :through => :subscriptions
  has_many :newsitems, :dependent => :destroy

  validates :url, presence: true

  scope :for_nav, -> { order('url ASC') }

  scope :with_unread_count, -> {
    joins(:newsitems)
      .select('feeds.*, sum(case when newsitems.unread then 1 else 0 end) as unreads')
      .group('feeds.id')
  }

  scope :with_unread_newsitems, -> {
    joins(:newsitems).where('newsitems.unread = ?', true).group('feeds.id')
  }

  scope :most_recent, -> {
    order('updated_at DESC').for_nav
  }

  before_save :sanitize_url

  def to_param
    "#{id}-#{(title || '').downcase.strip.gsub(/[\s\/#\?\.]/, '-')}"
  end

  def favicon
    url = URI.parse(self.url)
    "https://plus.google.com/_/favicon?domain=#{url.host || self.url}"
  end

  def unread_newsitems
    newsitems.where(:unread => true)
  end

  def unread_count
    unread_newsitems.count
  end

  def mark_all_as_read
    counter = unread_count
    unread_newsitems.update_all(:unread => false)
    counter
  end

  def clear_read_news(offset = nil)
    offset ||= Kaminari.config.default_per_page
    newsitems.for_view.where(:unread => false).offset(offset).destroy_all
  end

  private

  def sanitize_url
    self.url.gsub!(/\s+/, '')
    self.url.prepend('http://') unless \
      url.start_with?('http://') || url.start_with?('https://')
  end
end

# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  url         :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer
#  feed_url    :text
#  title       :text             default("( Untitled )"), not null
#  etag        :string(255)
#
# Indexes
#
#  index_feeds_on_category_id_and_id  (category_id,id) UNIQUE
#  index_feeds_on_feed_url            (feed_url) UNIQUE
#
