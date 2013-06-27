class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action do
    @new_feed = Feed.new
    @new_feed.category.build
    # XXX: Remove this later
    @categories = Category.all
  end
end
