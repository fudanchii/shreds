class FeedUpdater
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence { hourly.minute_of_hour(5, 25, 45) }

  def perform
    Feed.all.each { |f| FeedFetcher.perform_async(f.feed_url) }
  end
end
