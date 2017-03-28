class StaticController < ApplicationController
  skip_before_action :should_authenticate?, only: [:login]
  skip_before_action :fetch_subscriptions, :init_empty_subscription
  layout 'static'

  def login
    redirect_to root_path if current_user
  end
end
