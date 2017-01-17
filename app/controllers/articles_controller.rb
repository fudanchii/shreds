class ArticlesController < ApplicationController
  before_action :fetch_subscription

  def show
    respond_to do |fmt|
      fmt.json { render_serialized(@entry, EntryArticleSerializer) }
      fmt.html { render locals: { article: @entry.article } }
    end
  end

  def toggle_read
    @entry.update unread: !@entry.unread
  end

  private

  def fetch_subscription
    @subscription = current_user.subscriptions
                                .includes(entries: :article)
                                .includes(:feed)
                                .find_by!(feed_id: params[:feed_id].to_i)
    @entry = @subscription.entries
                          .select { |e| e.article_id == params[:id].to_i }
                          .first
    @feed = @subscription.feed
    raise ActiveRecord::RecordNotFound if @entry.nil?
  end
end
