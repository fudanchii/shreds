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

  scope :url_asc, -> { order('url ASC') }

  class << self
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

    def from_subscription_with_articles(subscription, options)
      articles = subscription.entries.where(subscription_id: subscription.id)
        .joins_article
        .select('articles.*, entries.unread, entries.subscription_id')
        .page(options[:page])
        .per(options[:articles_per_page])
      FeedWithArticles.new(subscription.feed, articles)
    end

    def from_subscriptions_with_unread_articles(subscriptions, options)
      articles = Article.from_subscriptions_with_unreads(subscriptions, options)
        .group_by(&:feed_id)
      where(id: subscriptions.pluck(:feed_id))
        .page(options[:page])
        .per(options[:feeds_per_page])
        .map {|feed| FeedWithArticles.new(feed, articles[feed.id]) }
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
    etag.present? && (newfeed.etag == etag) && !articles.empty?
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
    articles.each { |n| subscription.entries.build(article: n).save! }
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
