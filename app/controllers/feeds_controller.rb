class FeedsController < ApplicationController
  def index
    @feeds = FeedsIndexSerializer.new(
      current_user.subscriptions_list(
        page: params[:page].presence || 1,
        per_page: Figaro.env.index_item_per_page,
        per_feed: Figaro.env.index_item_per_feed
      )
    ).as_json
  end

  def show
    @feed = current_user.one_subscription(
      feed_id: params[:id],
      page: params[:page].presence || 1,
      per_page: Figaro.env.feed_item_per_page
    )
  end
end
