class FeedsController < ApplicationController
  def index
    @feeds = FeedsUnreadEntriesArticles.new(
      subscriptions: current_user.subscriptions,
      articles_per_feed: 3,
      page: current_page,
      feeds_per_page: 5).select!
  end

  def show
    @feed = FeedEntriesArticles.new(
      subscription: current_user.subscriptions
        .includes(:feed)
        .find_by(feed_id: params[:id]),
      articles_per_page: 15,
      page: current_page).select!
  end
end
