require 'feedzirra'

class FeedUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence { hourly.minute_of_hour(5, 25, 45) }

  def perform
    Category.all.each do |c|
      c.feeds.each { |f|
        FeedWorker.perform_async(f.id, :fetch)
      }
    end
  end
end
