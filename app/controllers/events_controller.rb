class EventsController < ApplicationController
  def watch
    @ev = EventsWatch.new(params[:watchList])
    @ev.execute && @payload = @ev.payload
    return render 'watch' unless @payload.empty?
    render :text => ''
  end
end
