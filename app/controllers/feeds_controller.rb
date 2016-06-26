class FeedsController < ApplicationController
  def index
    @feeds = Feed.from_subscriptions_with_unread_articles(
      current_user.subscriptions,
      articles_per_feed: 3,
      page: current_page,
      feeds_per_page: 5)
    respond_to do |format|
      format.html
      format.json { render_serialized(@feeds, FeedsIndexSerializer) }
    end
  end

  def mark_all_as_read
    Entry.where(subscription_id: current_user.subscriptions.pluck(:id))
      .update_all(unread: false)
    render json: { info: I18n.t("feed.all_marked_read") }
  end

  def mark_all_as_unread
    Entry.where(subscription_id: current_user.subscriptions.pluck(:id))
      .update_all(unread: true)
    render json: { info: I18n.t("feed.all_marked_unread") }
  end

  def mark_feed_as_read
    current_user.subscriptions.find_by(feed_id: params[:id])
      .entries.update_all(unread: true)
    render json: { info: I18n.t("feed.feed_marked_read") }
  end

  def mark_feed_as_unread
    current_user.subscriptions.find_by(feed_id: params[:id])
      .entries.update_all(unread: false)
    render json: { info: I18n.t("feed.feed_marked_unread") }
  end

  def show
    @feed = Feed.from_subscription_with_articles(
      current_user.subscriptions.includes(:feed).find_by(feed_id: params[:id]),
      articles_per_page: 15,
      page: current_page)
    respond_to do |format|
      format.html
      format.json { render_serialized(@feed, FeedArticlesSerializer) }
    end
  end
end
