require 'opml_file'

class FeedsController < ApplicationController
  respond_to :html, :json

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Kaminari::paginate_array(current_user.unread_feeds.to_ary).page(params[:page]).per 5
    respond_with @feeds
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @subscription = current_user.subscriptions
      .joins(:feed)
      .find_by! :feed_id => params[:id]
    @feed = @subscription.feed
    @entries = @subscription.entries.includes(:newsitem).for_view.page params[:page]
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
    filename = OPMLFile.new(params[:OPMLfile]).fullpath
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
    @subscription.entries.unread_entry.update_all :unread => false
  end

  def mark_all_as_read
    Entry.joins(:subscription)
      .where('subscriptions.user_id' => current_user.id)
      .unread_entry
      .update_all :unread => false
  end

end
