# frozen_string_literal: true

class UpdateFeed
  include Sidekiq::Worker

  sidekiq_options retry: false,
                  expires_in: 21.minutes

  def perform
    run_feed_fetcher
    tokens = $redis_pool.with { |conn| conn.hkeys('keepalive') }

    User.where(token: tokens).find_each do |user|
      subs = Subscription.group_by_categories(user.subscriptions.with_unread_count)
      MessageBus.publish('/updates', { data: NavigationListSerializer.new(subs).as_json }, user_ids: [user.token])
    end
  end

  def run_feed_fetcher
    counter = 0
    Feed.where(id: Subscription.pluck(:feed_id)).pluck(:feed_url).to_set.each do |s|
      counter += 1
      jid = FeedFetcher.perform_async s
      MessageBus.subscribe("/feed_fetcher-#{jid}") do |_|
        counter -= 1
        MessageBus.unsubscribe jid
      end
    end

    loop do
      break unless counter.positive?
      sleep 1
    end
  end
end
