class EventsController < ApplicationController
  def watch
    @payload = EventsWatchContext.new(params[:watchList]).have_payload.execute
    return render 'watch' unless @payload.empty?
    render :text => ''
  end
end
