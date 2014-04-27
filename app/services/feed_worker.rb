class FeedFetcher
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(uid, feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    fail ArgumentError if feed.is_a? Fixnum
    EntryNewsitems.new(uid, feed.sanitize!, feed_url).execute
  end
end
