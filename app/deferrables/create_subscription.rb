require 'feedbag'

class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(uid, url, category)
    user = User.find uid
    subscription = user.subscriptions.build category: create_category(category),
                                            feed: create_feed(url)
    User.transaction do
      subscription.save!
      subscription.feed.newsitems.each { |n| subscription.entries.build(newsitem: n).save! }
      FeedFetcher.new.perform subscription.feed.feed_url
      EventPool.add "create-#{jid}", view: 'create', category_id: subscription.category.id
    end
  rescue ActiveRecord::RecordNotFound
    EventPool.add "create-#{jid}", error: I18n.t('user.not_found')
  rescue ActiveRecord::RecordNotUnique
    EventPool.add "create-#{jid}", error: I18n.t('feed.subscribed')
  rescue Shreds::InvalidFeed => err
    EventPool.add "create-#{jid}", error: err.message
  end

  private

  def create_category(catname)
    catname ||= Category.default
    Category.find_or_create_by! name: catname
  rescue ActiveRecord::InvalidStatement
    retry
  end

  def create_feed(url)
    feed_url = Feedbag.find(url).first
    fail Shreds::InvalidFeed if feed_url.nil?
    feed = Feed.find_by feed_url: feed_url
    feed || Feed.create!(user_param url, feed_url)
  end

  def user_param(url, feed_url)
    ActionController::Parameters.new(url: url, feed_url: feed_url, title: url).permit!
  end
end
