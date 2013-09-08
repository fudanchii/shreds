class FeedsController < ApplicationController
  respond_to :html, :json

  rescue_from ActiveRecord::RecordNotUnique, with: :feed_already_exists

  # GET /feeds
  # GET /feeds.json
  def index
    respond_with(@feeds.page(params[:page]))
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])
    @newsitems = @feed.newsitems.page(params[:page])
    respond_with(@feed)
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @category = Category.where(name: params[:category][:name].presence || Category.default).first_or_create
    @new_feed = @category.feeds.build(feed_params)
    if @new_feed.save
      FeedWorker.perform_async(@new_feed.id, :fetch)
      flash[:success] = 'Feed was successfully created.'
      respond_with(@new_feed)
    else
      @category.destroy if @category and @category.is_custom_and_unused?
      respond_to do |format|
        format.html { render :index }
        format.json { render json: {error: 'Feed cannot be saved.'} }
      end
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

  def mark_as_read
    # FeedWorker.perform_async(params[:id], :mark_as_read)
    @feed = Feed.find(params[:id])
    @feed.mark_all_as_read
    respond_with(go_watch: "mark_as_read")
  end

  def mark_all_as_read
    # FeedWorker.perform_async(params[:id], :mark_all_as_read)
    respond_with(go_watch: "mark_all_as_read")
  end

  private
  def feed_params
    params.require(:feed).permit(:url, :title, :meta, :tag)
  end

  def feed_already_exists(exceptions)
    @category.destroy if @category and @category.is_custom_and_unused?
    flash[:danger] = 'Feed already exists.'
    respond_with(@new_feed)
  end
end
