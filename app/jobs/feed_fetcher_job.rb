require 'feedjira'

class FeedFetcherJob < ActiveJob::Base
  queue_as :feed_fetcher

  def perform(rfeed)
    feed = Feedjira::Feed.fetch_and_parse(rfeed.feed_url, Rails.configuration.feedjira)
    fail Shreds::InvalidFeed, I18n.t('feed.error.fetcher', code: feed) if feed.is_a? Fixnum
    feed.sanitize_entries!
    EntryNewsitems.new(feed, rfeed).execute
  end
end
