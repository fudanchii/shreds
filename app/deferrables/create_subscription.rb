class CreateSubscription
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(uid, url, category)
    if url.to_s.blank?
      fail Shreds::InvalidFeed, I18n.t('feed.error.empty_url')
    end
    user = User.find uid
    subscription = user.subscriptions.build feed: Feed.safe_create(url),
                                            category: Category.safe_create(category)
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
