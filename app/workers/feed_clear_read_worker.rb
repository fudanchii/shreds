class FeedClearReadWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence { daily.hour_of_day(2) }

  def perform
    Feed.all.each { |f| f.clear_read_news }
  end
end
