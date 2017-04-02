# frozen_string_literal: true

class UpdateFeed
  include Sidekiq::Worker

  sidekiq_options retry: false,
                  expires_in: 21.minutes

  def perform
    Subscription.find_each { |s| FeedFetcher.perform_async(s.feed.feed_url) }
  end
end
