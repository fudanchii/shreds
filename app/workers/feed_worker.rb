class FeedWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def create(url, category_name)
    feed_url = Feedbag.find(url).first
    fail if feed_url.nil?
    category = FeedCreationContext.new(category_name, url, feed_url).execute
                                  .have_category.and_then {|feed| fetch(feed.id) }
    EventPool.add("create-#{jid}", { view: 'create', category_id: category.id })
  rescue ActiveRecord::RecordNotUnique
    EventPool.add("create-#{jid}", { error: '<strong>Already subscribed</strong> to the feed.' })
  rescue => ex
    Rails.logger.warn ex.message
    EventPool.add("create-#{jid}", { error: '<strong>Can\'t find any feed,</strong> are you sure the url is valid?' })
  end

  def destroy(feed_id)
    feed_record = Feed.find(feed_id)
    feed_record.destroy
    EventPool.add("destroy-#{jid}", { view: 'destroy', category_id: feed_record.category.id })
  rescue => ex
    Rails.logger.warn ex.message
    EventPool.add("destroy-#{jid}", { error: '<strong>Can\'t unsubscribe</strong> from this feed.' })
  end

  def fetch(feed_id)
    feed_record = Feed.find(feed_id)
    feed = Feedzirra::Feed.fetch_and_parse(feed_record.feed_url)
    EntryNewsitemsContext.new(feed, feed_record).execute
  rescue => ex
    Rails.logger.warn ex.message
  end

  def mark_as_read(feed_id)
    feed_record = Feed.find(feed_id)
    feed_record.mark_all_as_read
    EventPool.add("markAsRead-#{jid}", { view: 'mark_feed_as_read', id: feed_id })
  rescue
    EventPool.add("markAsRead-#{jid}", { error: '<strong>Feed</strong> can not marked as read.' })
  end

  def perform(action, *params)
    send(action, *params)
  end
end
