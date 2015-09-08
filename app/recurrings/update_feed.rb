class UpdateFeed
  include Sidekiq::Worker

  sidekiq_options retry: false,
                  expires_in: 21.minute

  def perform
    Feed.find_each { |f| FeedFetcher.perform_async(f.feed_url) }
  end
end
