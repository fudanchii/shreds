class EventsController < ApplicationController

  before_action { @payload = {} }

  def watch
    watch_list = params[:watchList].split(',') if params[:watchList]
    unless watch_list.empty?
      result = EventPool.find(*watch_list)
      unless result.empty?
        watch_list.zip(result).each do |w, r|
          next if r.nil?
          data = JSON.parse r
          data['feed'] = Feed.with_unread_count.find data['id'] if data['id']
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
