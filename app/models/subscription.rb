class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :feed

  has_many :urls
  has_many :feeds, through: :urls
  has_many :entries, dependent: :destroy
  has_many :articles, through: :entries

  before_save :ensure_category

  scope :with_articles, -> { includes(:articles).order('articles.published desc, articles.id desc') }
  scope :with_unread_count, lambda {
    joins(:entries)
      .select('subscriptions.*, sum(case when entries.unread then 1 else 0 end) as unreads')
      .group('subscriptions.id')
  }
  scope :bundled_for_navigation, -> { with_unread_count.includes(:feed, :category).order(:feed_id) }

  def unread_count
    entries.where(unread: true).count
  end

  def clear_read_news(offset = Kaminari.config.default_per_page)
    entries.joins_article.where(unread: false).offset(offset).each do |e|
      e.article.destroy if e.article.unreads == 0
    end
  end

  def fetch_feeds!
    transaction do
      save!
      feed.create_entries_for self
      FeedFetcher.new.perform feed.feed_url
    end
  end

  private

  def ensure_category
    self.category_id = Category.find_by(name: Category.default).id unless category_id
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
#  index_subscriptions_on_feed_id_and_user_id                  (feed_id,user_id) UNIQUE
#
