require 'uri'
require 'feedbag'
require 'shreds/feed'

class Feed < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :categories, through: :subscriptions
  has_many :users, through: :subscriptions
  has_many :newsitems, dependent: :destroy

  validates :url, :feed_url, presence: true
  before_save :sanitize_url

  scope :for_nav, -> { order('url ASC') }

  # This method should guarantee multi-process /
  # multi-thread safeness.
  def self.safe_create(url)
    feed_url = Feedbag.find(url).first
    if feed_url.nil?
      fail Shreds::InvalidFeed, I18n.t('feed.invalid')
    end
    feed = where(feed_url: feed_url).first
    feed || create!(by_param url, feed_url)
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotUnique
    find_by! feed_url: feed_url
  end

  def to_param
    "#{id}-#{(title.presence || '(untitled)').downcase.strip.gsub(/[\s[:punct:]]+/, '-')}"
  end

  def favicon
    iurl = URI.parse(url)
    "https://plus.google.com/_/favicon?domain=#{iurl.host || url}"
  end

  def up_to_date_with?(newfeed)
    etag.present? && (newfeed.etag == etag) && (!newsitems.empty?)
  end

  def update_feed_url!
    feed_url = Feedbag.find(url).first
    fail Shreds::InvalidFeed if feed_url.nil?
    update_attributes!(feed_url: feed_url)
  end

  def add_newsitem(entry)
    nf = Newsitem.sanitize_field(entry)
    return if nf[:permalink].to_s.blank? || Newsitem.has?(nf[:permalink])
    transaction do
      news = newsitems.build nf
      news.save!
      subscriptions.each { |s| s.entries.build(newsitem: news).save! }
    end
  end

  def create_entries_for(subscription)
    newsitems.each { |n| subscription.entries.build(newsitem: n).save! }
  end

  def update_meta!(fields)
    fields.delete_if do |k, v|
      v.nil? ||
        (k == :title && title.present? && title == v) ||
        (k == :url && url.present? && url == v)
    end
    update_attributes!(fields) unless fields.empty?
  end

  private

  def sanitize_url
    url.strip!
    self.url = Shreds::Feed.to_valid_url(url) unless url.urlish?
  end

  def self.by_param(url, feed_url)
    ActionController::Parameters.new(url: url, feed_url: feed_url, title: url).permit!
  end
end

# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  url        :text             not null
#  created_at :datetime
#  updated_at :datetime
#  feed_url   :text
#  title      :text             default("( Untitled )"), not null
#  etag       :string
#
# Indexes
#
#  index_feeds_on_feed_url  (feed_url) UNIQUE
#
