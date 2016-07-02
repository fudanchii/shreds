class EventsController < ApplicationController
  before_action :fetch_subscriptions
  skip_before_action :init_empty_subscription

  def watch
    @ev = EventsWatch.new(params[:watchList].to_s).tap(&:execute)
    @payload = @ev.payload
    if @payload.empty?
      render plain: ''
    else
      render json: @payload
    end
  end
end
