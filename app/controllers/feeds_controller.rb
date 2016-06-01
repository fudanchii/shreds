class FeedsController < ApplicationController
  def create
  end

  def index
    @feeds = Feed.from_subscriptions_with_unread_articles(
      current_user.subscriptions,
      articles_per_feed: 3,
      page: current_page,
      feeds_per_page: 5)
  end

  def show
    @feed = Feed.from_subscription_with_articles(
      current_user.subscriptions.includes(:feed).find_by(feed_id: params[:id]),
      articles_per_page: 15,
      page: current_page)
  end
end
