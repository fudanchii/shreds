# frozen_string_literal: true

class ClearReadNews
  include Sidekiq::Worker

  sidekiq_options retry: false,
                  expires_in: 24.hours

  def perform
    Subscription.find_each(&:clear_read_news)
  end
end
