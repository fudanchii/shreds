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
    jid = FeedWorker.perform_async(:create, params[:feed][:url], \
      params[:category][:name].presence || Category.default)
    respond_to do |fmt|
      fmt.html {
        flash[:info] = 'Hold on, your newsfeed is in the making.'
        redirect_to '/'
      }
      fmt.json { render :json => { watch: "create-#{jid}" } }
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    jid = FeedWorker.perform_async(:destroy, params[:id])
    respond_to do |fmt|
      fmt.json { render :json => { watch: "destroy-#{jid}" } }
    end
  end

  def mark_as_read
    jid = FeedWorker.perform_async(:mark_as_read, params[:id])
    respond_to do |fmt|
      fmt.json { render :json => { watch: "markAsRead-#{jid}" } }
    end
  end

  def mark_all_as_read
    jid = FeedWorker.perform_async(:mark_all_as_read)
    respond_to do |fmt|
      fmt.json { render :json => { watch: "markAllAsRead-#{jid}" } }
    end
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
