require 'authentication'

class ApplicationController < ActionController::Base
  include Shreds::Auth
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :feed_not_found

  before_action :should_authenticate?
  before_action :fetch_subscriptions, :init_props

  private

  def should_authenticate?
    redirect_to('/login') unless authenticated?
  end

  def fetch_subscriptions
    newsitems = Newsitem.select('distinct on (feed_id) *')
      .where(:feed_id => current_user.subscriptions.pluck(:feed_id))
      .order(:feed_id).for_view.to_ary
    @subscriptions = current_user.subscriptions.with_unread_count
      .includes(:feed, :category).order(:feed_id).reduce({}) do |prev, current|
      prev[current.category.name] ||= []
      prev[current.category.name] << {
        :feed => current.feed,
        :unreads => current.unreads,
        :latest => newsitems.shift
      }
      prev
    end
  end

  def init_props
    @subscription = current_user.subscriptions.build
    @category = @subscription.category = Category.new
    @new_feed = @subscription.feed = Feed.new
  end

  def feed_not_found(exceptions)
    respond_to do |fmt|
      fmt.html do
        flash[:danger] = I18n.t('feed.not_found')
        redirect_to '/'
      end
      fmt.json { render :json => {error: I18n.t('feed.not_found')} }
    end
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
