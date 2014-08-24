class NewsitemsController < ApplicationController
  respond_to :html, :json

  before_action :fetch_subscription

  def show
    @feed = @subscription.feed
    respond_with @entry do |fmt|
      fmt.html { render :locals => { :newsitem => @entry.newsitem } }
    end
  end

  def toggle_read
    @entry.update :unread => !@entry.unread
  end

  private

  def fetch_subscription
    @subscription = current_user.subscriptions.includes(:entries).find_by! :feed_id => params[:feed_id]
    @entry = @subscription.entries.select {|e| e.newsitem_id == params[:id].to_i }.first
    fail ActiveRecord::RecordNotFound if @entry.nil?
  end
end
