class NewsitemsController < ApplicationController
  respond_to :html, :json

  before_action :fetch_subscription

  def show
    @feed = @subscription.feed
    @newsitem = @subscription.newsitems.find params[:id]
    respond_with @newsitem
  end

  def toggle_read
    @entry = @subscription.entries.find_by :newsitem_id => params[:id]
    @entry.update :unread => !@entry.unread
  end

  private

  def fetch_subscription
    @subscription = current_user.subscriptions.find_by :feed_id => params[:feed_id]
    fail ActiveRecord::RecordNotFound if @subscription.nil? || \
      @subscription.newsitems.empty?
  end
end
