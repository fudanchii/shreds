class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(uid, url, category)
    user = User.find uid
    feeds = Feed.safe_create url
    subscription = user.subscriptions.create! feed: feeds.first,
                                              category: Category.safe_create(category)
    subscription.fetch_feeds!
    MessageBus.publish("/create-#{jid}", { result: { subscription_id: subscription.id } }.to_json)
  rescue ActiveRecord::RecordNotFound
    MessageBus.publish("/create-#{jid}", { error: I18n.t('user.not_found') }.to_json)
  rescue ActiveRecord::RecordNotUnique
    MessageBus.publish("/create-#{jid}", { error: I18n.t('feed.subscribed') }.to_json)
  rescue => err
    MessageBus.publish("/create-#{jid}", { error: err.message }.to_json)
  end
end
