class ClearReadNews
  include Sidekiq::Worker

  sidekiq_options retry: false,
                  expires_in: 24.hour

  def perform
    Subscription.find_each(&:clear_read_news)
  end
end
