class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :feed_not_found

  before_action do
    @category = Category.new
    @new_feed = @category.feeds.build
    # XXX: Remove this later
    @categories = Category.for_nav
  end

  private

  def feed_not_found(exceptions)
    flash[:danger] = I18n.t('feed.not_found').html_safe
    redirect_to '/'
  end

  def may_respond_with(opts)
    respond_to do |fmt|
      fmt.html do
        flash[:info] = opts[:html][:info]
        redirect_to opts[:html][:redirect_to]
      end
      fmt.json { render :json => opts[:json] }
    end
  end

end
