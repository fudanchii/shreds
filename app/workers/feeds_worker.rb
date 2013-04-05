require 'feedzirra'
class FeedWorker
  include Sidekiq::Worker

  def perform(feed_id)
    feed_record = Feed.find(feed_id)
    xml = Feedzirra::Feed.fetch_raw(feed_record.permalink)
    feed_record.update_cache(xml)
  end
end
