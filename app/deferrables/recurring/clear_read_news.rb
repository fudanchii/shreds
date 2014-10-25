class ClearReadNews
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false,
                  expires_in: 24.hour

  recurrence { daily.hour_of_day(2) }

  def perform
    Subscription.find_each(&:clear_read_news)
  end
end
