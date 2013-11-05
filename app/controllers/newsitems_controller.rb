class NewsitemsController < ApplicationController
  respond_to :html, :json

  before_action do
    @feed = Feed.includes(:newsitems)
      .where('feeds.id = ? and newsitems.id = ?', params[:feed_id].to_i, params[:id]).to_ary.first
    @newsitem = @feed.newsitems.first
  end

  def show
    respond_with(@newsitem)
  end

  def toggle_read
    @newsitem.update(:unread => !@newsitem.unread)
  end
end
