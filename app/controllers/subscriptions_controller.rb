class SubscriptionsController < ApplicationController
  # For managing categories
  def index
  end

  # For managing Feeds subscription
  def show
  end

  def create
    jid = CreateSubscription.perform_async(
      current_user, feed_params[:url], feed_params[:category])
    may_respond_with(
      html: { info: I18n.t('subscription.created.html') },
      json: { jid: jid }
    )
  end
end
