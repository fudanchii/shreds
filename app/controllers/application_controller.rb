require 'shreds/authentication'

class ApplicationController < ActionController::Base
  include Shreds::Auth
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :feed_not_found

  prepend_before_action :should_authenticate?

  before_action :fetch_subscriptions, unless: -> { request.format == :json }
  before_action :init_empty_subscription, unless: -> { request.format == :json }

  protected

  def current_page
    return params[:page] if params[:page].to_i > 0
    1
  end

  def error_response(message, code)
    respond_to do |fmt|
      fmt.html do
        flash[:danger] = message
        redirect_to '/'
      end
      fmt.json { render json: { error: message }, status: code }
    end
  end

  private

  def should_authenticate?
    redirect_to('/login') unless authenticated?
  end

  def fetch_subscriptions
    @subscriptions = NavigationListSerializer.new(current_user).as_json
  end

  def init_empty_subscription
  end

  def feed_not_found(_exceptions)
    error_response I18n.t('feed.not_found'), :not_found
  end

  def may_respond_with(opts)
    respond_to do |fmt|
      fmt.html do
        if opts[:html].present?
          flash[:info] = opts[:html][:info]
          redirect_to opts[:html][:redirect_to] if opts[:html][:redirect_to].present?
        end
      end
      fmt.json { render json: opts[:json] }
    end
  end
end
