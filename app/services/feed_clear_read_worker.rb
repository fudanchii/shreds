class FeedClearReadWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence { daily.hour_of_day(2) }

  def perform
    Subscription.find_each { |s| s.clear_read_news }
  end
end
