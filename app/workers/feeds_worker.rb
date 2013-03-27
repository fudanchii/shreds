require 'feedzirra'
class FeedWorker
  include Sidekiq::Worker

  def perform(feed_id)
    feed_record = Feed.find(feed_id)
    feed = FeedZirra::Feed.fetch_and_parse(feed_record.permalink)
    feed_record.update_cache(feed)
  end
end
