require 'uri'
require 'feedbag'
require 'shreds/feed'

class Feed < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :categories, through: :subscriptions
  has_many :users, through: :subscriptions
  has_many :articles, dependent: :destroy

  validates :url, :feed_url, presence: true
  before_save :sanitize_url

  scope :for_nav, -> { order('url ASC') }

  class << self
    # This method should guarantee multi-process /
    # multi-thread safeness.
    def safe_create(url)
      urls = Feedbag.find(url)
      raise Shreds::InvalidFeed, I18n.t('feed.invalid') if urls.nil? || urls.empty?
      urls.map do |feed_url|
        begin
          where(feed_url: feed_url).first_or_create! by_param(url, feed_url)
        rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotUnique
          find_by! feed_url: feed_url
        end
      end
    end

    private

    def by_param(url, feed_url)
      ActionController::Parameters.new(url: url, feed_url: feed_url, title: url).permit!
    end
  end

  def to_param
    "#{id}-#{(title.presence || '(untitled)').downcase.strip.gsub(/[\s[:punct:]]+/, '-')}"
  end

  def favicon
    iurl = URI.parse(url)
    "https://plus.google.com/_/favicon?domain=#{iurl.host || url}"
  end

  def up_to_date_with?(newfeed)
    etag.present? && (newfeed.etag == etag) && !newsitems.empty?
  end

  def update_feed_url!
    feed_url = Feedbag.find(url).first
    raise Shreds::InvalidFeed if feed_url.nil?
    update_attributes!(feed_url: feed_url)
  end

  def add_article(entry)
    nf = Article.sanitize_field(entry)
    return if nf[:permalink].to_s.blank? || Article.has?(nf[:permalink])
    transaction do
      news = articles.build nf
      news.save!
      subscriptions.each { |s| s.entries.build(article: news).save! }
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

  def update_stats!(status)
    update_attributes! last_status: status
  end

  private

  def sanitize_url
    url.strip!
    self.url = Shreds::Feed.to_valid_url(url) unless url.urlish?
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
#  feed_url    :text
#  title       :text             default("( Untitled )"), not null
#  etag        :string
#  last_status :string
#
# Indexes
#
#  index_feeds_on_feed_url  (feed_url) UNIQUE
#
