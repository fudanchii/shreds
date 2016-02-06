require 'feedjira'

class FeedFetcher
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    feed_status = 'success'
    EntryNewsitems.new(feed, feed_url).execute
  rescue => err
    feed_status = err.message
  ensure
    Feedurl.where(url: feed_url).update_all last_fetch_status: feed_status, last_fetch_time: DateTime.now
  end
end
