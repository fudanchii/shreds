class UsersController < ApplicationController
  skip_before_action :fetch_subscriptions, :init_empty_subscription

  def feed_subscriptions
    @categories = Category.includes(:subscriptions, :feeds)
                  .where('subscriptions.user_id' => current_user.id)
  end
end
