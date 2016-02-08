require 'feedjira'

class FeedFetcher
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    feed_status = 'success'
  rescue => err
    feed_status = err.message
  ensure
    EntryNewsitems.new(feed, feed_url, feed_status).execute
  end
end
