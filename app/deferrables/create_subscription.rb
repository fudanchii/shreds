class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(uid, url, category)
    user = User.find uid
    feeds = Feed.safe_create url
    subscription = user.subscriptions.create! feed: feeds.first,
                                              category: Category.safe_create(category)
    subscription.fetch_feeds!
    sub = Subscription.group_by_categories(user.subscriptions.with_unread_count)
    MessageBus.publish("/create-#{jid}", info: I18n.t('feed.subscribed_to', url: url),
                                         data: NavigationListSerializer.new(sub).as_json)
  rescue ActiveRecord::RecordNotFound
    MessageBus.publish("/create-#{jid}", error: I18n.t('user.not_found'))
  rescue ActiveRecord::RecordNotUnique
    MessageBus.publish("/create-#{jid}", error: I18n.t('feed.subscribed'))
  rescue => err
    MessageBus.publish("/create-#{jid}", error: err.message)
  end
end
