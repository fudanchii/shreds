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
    params[:feed][:category] = "uncategorized" if params[:feed][:category].blank?
    @category = Category.where(name: params[:feed][:category]).first_or_create
    params[:feed].delete(:category)
    @feed = Feed.new(params[:feed])
    @feed.category = @category
    if @feed.save
      # delay fetching feeds by 2 seconds
      # make sure @feed is commited to database
      FeedWorker.perform_in(2.seconds, @feed.id)
      flash[:notice] = 'Feed was successfully created.'
    end
    respond_with(@feed)
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    flash[:notice] = 'Feed was successfully removed.'
    respond_with(@feed)
  end
end
