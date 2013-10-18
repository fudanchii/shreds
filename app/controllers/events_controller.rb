class EventsController < ApplicationController

  before_action { @payload = {} }

  def watch
    watchList = params[:watchList].split(',') if params[:watchList]
    unless watchList.empty? then
      result = EventPool.find *watchList
      unless result.empty? then
        watchList.zip(result).each do |w, r|
          next if r.nil?
          data = JSON.parse r
          data['feed'] = Feed.find data['id'] if data['id']
          data['category'] = Category.find data['category_id'] if data['category_id']
          @payload[w] = data
          EventPool.remove w
        end
        return render 'watch' unless @payload.empty?
      end
    end
    render :text => ''
  end

end
