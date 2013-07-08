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
    raise "URL cannot be blank!" if params[:feed][:url].blank?
    @category = Category.where(name: params[:category][:name].presence || "uncategorized").first_or_create
    @feed = @category.feeds.build(feed_params)
    if @feed.save
      FeedWorker.perform_async(@feed.id)
      flash[:success] = 'Feed was successfully created.'
      respond_with(@feed) && return
    else
      @category.destroy if @category.name != "uncategorized"
      raise "Cannot save #{@feed.inspect}"
    end
  rescue Exception => e
    flash[:error] = "#{e}"
    logger.fatal "[FeedsController#create] #{e}"
    respond_to do |format|
      format.html { redirect_to feeds_path }
      format.json { render json: {error: flash[:error]} }
    end
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
