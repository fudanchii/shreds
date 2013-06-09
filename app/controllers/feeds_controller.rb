class FeedsController < ApplicationController

  before_filter do
    @category = Category.new
    @new_feed = Feed.new
    @new_feed.category = @category
    # XXX: Remove this later
    @categories = Category.all
  end

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  end

  # POST /feeds
  # POST /feeds.json
  def create
    params[:feed][:category] = "uncategorized" if params[:feed][:category].blank?
    @category = Category.where(name: params[:feed][:category]).first_or_create
    params[:feed].delete(:category)
    @feed = Feed.new(params[:feed])
    @feed.category = @category
    respond_to do |format|
      if @feed.save
        # delay fetching feeds by 2 seconds
        # make sure @feed is commited to database
        FeedWorker.perform_in(2.seconds, @feed.id)
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end
end
