# frozen_string_literal: true

class FeedsController < ApplicationController
  def index
    @feeds = Feed.from_subscriptions_with_unread_articles(
      current_user.subscriptions,
      articles_per_feed: 3,
      page: current_page,
      feeds_per_page: 5
    )
    respond_to do |format|
      format.html
      format.json { render_serialized(@feeds, FeedsIndexSerializer) }
    end
  end

  def show
    @feed = Feed.from_subscription_with_articles(
      current_user.subscriptions.includes(:feed).find_by(feed_id: params[:id]),
      articles_per_page: Kaminari.config.default_per_page,
      page: current_page
    )
    respond_to do |format|
      format.html
      format.json { render_serialized(@feed, FeedArticlesSerializer) }
    end
  end
end
