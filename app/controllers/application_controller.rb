class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action do
    @feeds = Feed.all
    @category = Category.new
    @new_feed = @category.feeds.build
    # XXX: Remove this later
    @categories = Category.all
  end
end
