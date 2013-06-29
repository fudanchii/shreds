class FeedsController < ApplicationController
  respond_to :html, :json

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all
    respond_with(@feeds)
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])
    respond_with(@feed)
  end

  # POST /feeds
  # POST /feeds.json
  def create
    category = Category.where(name: params[:category][:name].presence || "uncategorized").first_or_create
    @feed = Feed.new(feed_params)
    @feed.category = category
    if @feed.save
      FeedWorker.perform_async(@feed.id)
      flash[:success] = 'Feed was successfully created.'
      respond_with(@feed) && return
    end
    flash[:error] = 'Cannot create feed with these data.'
    redirect_to feeds_path
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    flash[:notice] = 'Feed was successfully removed.'
    respond_with(@feed)
  end

  private
  def feed_params
    params.require(:feed).permit(:url, :title, :meta, :tag)
  end
end
