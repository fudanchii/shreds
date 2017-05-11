# frozen_string_literal: true

class UpdateFeed
  include Sidekiq::Worker

  sidekiq_options retry: false,
                  expires_in: 21.minutes

  def perform
    Subscription.find_each { |s| FeedFetcher.perform_async(s.feed.feed_url) }
    tokens = $redis_pool.hkeys('keepalive')
    User.where(token: tokens).find_each do |user|
      subs = Subscription.group_by_categories(user.subscriptions.with_unread_count)
      MessageBus.publish('/updates', NavigationListSerializer.new(subs).as_json, user_ids: [user.token])
    end
  end
end
