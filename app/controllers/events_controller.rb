class EventsController < ApplicationController
  def watch
    watchList = params[:watchList].split if params[:watchList]
    unless watchList.empty? then
      result = $redis.mget(*watchList)
      unless result.empty? then
        idx = 0
        # XXX: Need proper atomic redis get-then-delete, i.e.
        # Avoid racing condition where key was just created when delete being called.
        watchList.each {|w| $redis.del(w) unless result[idx].nil?; idx += 1 }
        idx, rmap = 0, {}
        result.each {|r| rmap[watchList[idx]] = JSON.parse(r) unless r.nil?; idx += 1 }
        return render(:json => rmap) unless rmap.empty?
      end
    end
    render :text => ''
  end
end
