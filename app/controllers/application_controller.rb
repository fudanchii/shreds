class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action do
    @category = Category.new
    @new_feed = Feed.new
    @new_feed.category = @category
    # XXX: Remove this later
    @categories = Category.all
  end
end
