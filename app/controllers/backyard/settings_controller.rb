module Backyard
  class SettingsController < ApplicationController
    skip_before_action :fetch_subscriptions, :init_empty_subscriptions
    layout 'backyard'

    def activities
    end

    def subscriptions
      @subscriptions = current_user.subscriptions
    end

    def update
    end
  end
end
