class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :feed_not_found

  before_action do
    @feeds = Feed.all
    @category = Category.new
    @new_feed = @category.feeds.build
    # XXX: Remove this later
    @categories = Category.all
  end

  private
  def feed_not_found(exceptions)
    flash[:danger] = '<strong>Feed</strong> not found.'.html_safe
    respond_to do |fmt|
      fmt.html { redirect_to '/' }
    end
  end

end
