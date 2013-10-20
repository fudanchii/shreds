class FeedsController < ApplicationController
  respond_to :html, :json

  rescue_from ActiveRecord::RecordNotFound, :with => :feed_not_found

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
        flash[:info] = 'Hold on, now printing your newsfeed.'
        redirect_to '/'
      }
      fmt.json { render :json => { watch: "create-#{jid}" } }
    end
  end

  def create_from_opml
    jid = OPMLWorker.save_file(params[:OPMLfile])
    render :json => { watch: "opml-#{jid}" }
  rescue OPMLWorkerError => ex
    render :json => { error: ex.message.html_safe }
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

  def feed_not_found(exceptions)
    flash[:danger] = '<strong>Feed</strong> not found.'.html_safe
    respond_to do |fmt|
      fmt.html { redirect_to '/' }
    end
  end
end
