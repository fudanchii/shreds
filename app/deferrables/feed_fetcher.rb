require 'feedjira'

class FeedFetcher
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url, Rails.configuration.feedjira)
    if feed.is_a?(Fixnum) && feed != 404
      fail Shreds::InvalidFeed, I18n.t('feed.error.fetcher', code: feed)
    end
    EntryNewsitems.new(feed, feed_url).execute
  end
end
