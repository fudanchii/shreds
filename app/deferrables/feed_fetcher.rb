# frozen_string_literal: true

require 'feedjira'

class FeedFetcher
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(feed_url)
    begin
      feed = Feedjira::Feed.fetch_and_parse(feed_url)
      feed_status = 'success'
    rescue => err
      feed_status = err.message
    end

    EntryArticles.new(feed, feed_url, feed_status).execute
    MessageBus.publish("/feed_fetcher-#{jid}", true)
  rescue
    MessageBus.publish("/feed_fetcher-#{jid}", true)
    raise
  end
end
