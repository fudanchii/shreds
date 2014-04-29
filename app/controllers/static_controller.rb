class StaticController < ApplicationController
  skip_before_action :should_authenticated?, :only => [:login]
  skip_before_action :fetch_subscriptions, :init_props
  layout 'static'

  def login
  end
end
