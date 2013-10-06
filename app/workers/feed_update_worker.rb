class FeedUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence { hourly.minute_of_hour(5, 25, 45) }

  def perform
    Feed.all.each { |f| FeedWorker.perform_async(:fetch, f.id) }
  end
end
