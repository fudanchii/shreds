class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(uid, url, category)
    user = User.find uid
    feeds = Feed.safe_create url
    subscription = user.subscriptions.build feed: feeds.first,
                                            category: Category.safe_create(category)
    feeds.each { |feed| subscription.feeds << feed }
    subscription.fetch_feeds!
    EventPool.add "create-#{jid}", view: 'create', category_id: subscription.category.id
  rescue ActiveRecord::RecordNotFound
    EventPool.add "create-#{jid}", error: I18n.t('user.not_found')
  rescue ActiveRecord::RecordNotUnique
    EventPool.add "create-#{jid}", error: I18n.t('feed.subscribed')
  rescue => err
    EventPool.add "create-#{jid}", error: err.message
  end
end
