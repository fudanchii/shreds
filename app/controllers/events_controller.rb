class EventsController < ApplicationController

  before_action { @payload = {} }

  def watch
    watch_list = params[:watchList].split(',') if params[:watchList]
    unless watch_list.empty?
      result = EventPool.find(*watch_list)
      unless result.empty?
        watch_list.zip(result).each do |w, r| next if r.nil?
          @payload[w] = JSON.parse r
          @payload[w]['feed'] = Feed.find @payload[w]['id'] if @payload[w]['id']
          @payload[w]['category'] = Category.find @payload[w]['category_id'] if @payload[w]['category_id']
          EventPool.remove w
        end
        return render 'watch' unless @payload.empty?
      end
    end
    render :text => ''
  end

end
