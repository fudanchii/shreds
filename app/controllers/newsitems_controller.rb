# == Schema Information
#
# Table name: newsitems
#
#  id         :integer          not null, primary key
#  permalink  :text
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  content    :text
#  author     :text
#  title      :text
#  published  :datetime         not null
#  summary    :text
#
# Indexes
#
#  index_newsitems_on_feed_id_and_id  (feed_id,id) UNIQUE
#

class NewsitemsController < ApplicationController
  before_action :fetch_subscription

  def show
    respond_to do |fmt|
      fmt.json
      fmt.html { render locals: { newsitem: @entry.newsitem } }
    end
  end

  def toggle_read
    @entry.update unread: !@entry.unread
  end

  private

  def fetch_subscription
    @subscription = current_user.subscriptions
                                .includes(:entries, :feed).find_by! feed_id: params[:feed_id]
    @entry = @subscription.entries.select { |e| e.newsitem_id == params[:id].to_i }.first
    @feed = @subscription.feed
    raise ActiveRecord::RecordNotFound if @entry.nil?
  end
end
