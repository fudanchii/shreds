require 'uploadann'

class FeedsController < ApplicationController
  respond_to :html, :json

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = current_user.recent_feeds.with_unread_newsitems \
      .page(params[:page]).per 5
    respond_with @feeds
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = current_user.feeds.find params[:id]
    @newsitems = @feed.newsitems.for_view.page params[:page]
    respond_with @feed 
  end

  # POST /feeds
  # POST /feeds.json
  def create
    jid = CreateSubscription.perform_async current_user.id, params[:feed][:url], \
      params[:category][:name].presence
    may_respond_with( \
      :html => { :info => I18n.t('feed.created'), :redirect_to => '/' }, \
      :json => { watch: "create-#{jid}" }
    )
  end

  def create_from_opml
    file = Uploadann.new(params[:OPMLfile])
    jid = ProcessOPML.perform_async file.name
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
    subs = current_user.subscriptions.find_by! :feed_id => params[:id]
    subs.entries.each &:mark_as_read
  end

  def mark_all_as_read
    current_user.subscriptions.each {|subs| subs.entries.each &:mark_as_read } 
  end

end
