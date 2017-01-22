require 'uri'
require 'feedbag'
require 'shreds/feed'

class Feed < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :categories, through: :subscriptions
  has_many :users, through: :subscriptions
  has_many :entries, through: :subscriptions
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

    def from_subscription_with_articles(sub, opt)
      articles = sub.entries.where(subscription_id: sub.id)
                    .joins_article
                    .select('articles.*, entries.unread, entries.subscription_id')
                    .page(opt[:page])
                    .per(opt[:articles_per_page])
      FeedWithArticles.new(sub.feed, articles, sub.category_id, sub.id)
    end

    def sorted_by_published_date(subs)
      sql = joins(subscriptions: %w(articles entries)).select(<<-SQL).to_sql
      feeds.*, articles.published as published, entries.unread as unread,
      row_number() over (
        partition by feeds.id
        order by entries.unread desc, published desc, feeds.title asc
      ) as row_num
      SQL
      select('*').from(Arel.sql("(#{sql}) feeds"))
                 .where(id: subs.map(&:feed_id), unread: true, row_num: 1)
                 .order('published desc')
    end

    def from_subscriptions_with_unread_articles(subs, opt)
      articles = Article.from_subscriptions_with_unreads(subs, opt)
                        .group_by(&:feed_id)
      categories = subs.each_with_object({}) { |n, rs| rs[n.feed_id] = n.category_id; }
      sids = subs.each_with_object({}) { |s, h| h[s.feed_id] = s.id; }
      sorted_by_published_date(subs).page(opt[:page]).per(opt[:feeds_per_page]).map do |feed|
        next if articles[feed.id].nil?
        FeedWithArticles.new(feed, articles[feed.id], categories[feed.id], sids[feed.id])
      end.compact
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
