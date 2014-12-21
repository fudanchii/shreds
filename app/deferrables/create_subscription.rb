require 'feedbag'

class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(uid, url, category)
    user = User.find uid
    subscription = user.subscriptions.build feed: create_feed(url),
                                            category: Category.safe_create(category)
    subscription.fetch_feeds!
    EventPool.add "create-#{jid}", view: 'create', category_id: subscription.category.id
  rescue ActiveRecord::RecordNotFound
    EventPool.add "create-#{jid}", error: I18n.t('user.not_found')
  rescue ActiveRecord::RecordNotUnique
    EventPool.add "create-#{jid}", error: I18n.t('feed.subscribed')
  rescue Shreds::InvalidFeed => err
    EventPool.add "create-#{jid}", error: err.message
  end

  private

  def create_feed(url)
    feed_url = Feedbag.find(url).first
    fail Shreds::InvalidFeed if feed_url.nil?
    Feed.safe_create url, feed_url
  end
end
