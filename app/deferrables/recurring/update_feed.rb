class UpdateFeed
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false,
                  expires_in: 21.minute

  recurrence { hourly.minute_of_hour(5, 25, 45) }

  def perform
    Feed.find_each { |f| FeedFetcherJob.perform_later(f) }
  end
end
