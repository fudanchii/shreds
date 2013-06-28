class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action do
    catname = params[:category] ? params[:category][:name] : ""
    @category = Category.where(name: catname).first_or_create
    @new_feed = @category.feeds.build
    # XXX: Remove this later
    @categories = Category.all
  end
end
