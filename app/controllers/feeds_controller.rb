require 'opml_file'

class FeedsController < ApplicationController
  respond_to :html, :json

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Kaminari.paginate_array(current_user.unread_feeds).page(params[:page]).per 5
    respond_with @feeds
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @subscription = current_user.subscriptions.find_by! :feed_id => params[:id]
    @feed = @subscription.feed
    @entries = @subscription.entries.for_view.page params[:page]
    respond_with @feed
  end

  # POST /feeds
  # POST /feeds.json
  def create
    jid = CreateSubscription.perform_async current_user.id,
          params[:feed][:url], params[:category][:name].presence
    may_respond_with(
      :html => { :info => I18n.t('feed.created'), :redirect_to => '/' },
      :json => { watch: "create-#{jid}" }
    )
  end

  def create_from_opml
    if request.headers['X-OPML-File'].present?
      filename = request.headers['X-OPML-File']
    else
      filename = OPMLFile.new(params[:OPMLfile]).fullpath
    end
    jid = ProcessOPML.perform_async current_user.id, filename
    render :json => { watch: "opml-#{jid}" }
  rescue UploadError => ex
    render :json => { error: ex.message.html_safe }
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    current_user.subscriptions.find_by!(:feed_id => params[:id]).destroy
  end

  def mark_as_read
    @subscription = current_user.subscriptions.find_by! :feed_id => params[:id]
    @subscription.entries.each &:mark_as_read
  end

  def mark_all_as_read
    current_user.subscriptions.each {|subs| subs.entries.each &:mark_as_read }
  end

end
