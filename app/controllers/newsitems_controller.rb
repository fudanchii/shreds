class NewsitemsController < ApplicationController
  respond_to :html, :json

  before_action do
    @feed = Feed.find(params[:feed_id])
    @newsitem = @feed.newsitems.find(params[:id])
  end

  def show
    respond_with(@newsitem)
  end

  def toggle_read
    @newsitem.update(unread: !@newsitem.unread )
  end
end
