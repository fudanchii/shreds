require 'authentication'

class ApplicationController < ActionController::Base
  include Shreds::Auth
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :feed_not_found

  prepend_before_action :should_authenticate?

  before_action :fetch_subscriptions, unless: -> { request.format == :json }
  before_action :init_empty_subscription, unless: -> { request.format == :json }

  private

  def should_authenticate?
    redirect_to('/login') unless authenticated?
  end

  def fetch_subscriptions
    @subscriptions = current_user.bundled_subscriptions
  end

  def init_empty_subscription
    @subscription = current_user.subscriptions.build
    @category = @subscription.category = Category.new
    @new_feed = @subscription.feed = Feed.new
  end

  def feed_not_found(_exceptions)
    respond_to do |fmt|
      fmt.html do
        flash[:danger] = I18n.t('feed.not_found')
        redirect_to '/'
      end
      fmt.json { render json: { error: I18n.t('feed.not_found') }, status: 404 }
    end
  end

  def may_respond_with(opts)
    respond_to do |fmt|
      fmt.html do
        flash[:info] = opts[:html][:info]
        redirect_to opts[:html][:redirect_to]
      end
      fmt.json { render json: opts[:json] }
    end
  end
end
