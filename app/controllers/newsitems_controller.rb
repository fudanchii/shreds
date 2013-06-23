class NewsitemsController < ApplicationController
  respond_to :html, :json

  before_filter do
    @feed = Feed.find(params[:feed_id])
    @newsitem = @feed.newsitems.find(params[:id])
  end

  def show
    respond_with(@newsitem)
  end
end
