class NewsitemsController < ApplicationController
  before_filter do
    @feed = Feed.find(params[:feed_id])
    @newsitem = @feed.newsitems.find(params[:id])
  end

  def show
    respond_to do |format|
      format.html
      format.json { render  json: @newsitem }
    end
  end
end
