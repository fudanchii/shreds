class EventsWatchContext < BaseContext
  class_attribute :payload, :watch_list

  at_execution :fetch_events

  def initialize(watch_str)
    self.payload = {}
    self.watch_list = has_update_feed(watch_str.split(','))
  end

  def has_update_feed(list)
    return list unless f_idx = list.find_index {|w| w == 'updateFeed' }
    list.delete_at f_idx
    payload['updateFeed'] = {'view' => 'feed_update'}
    list
  end

  private

  def fetch_events
    return if watch_list.empty?
    result = EventPool.find(*watch_list)
    watch_list.zip(result).each do |w, r|
      next if r.nil?
      data = JSON.parse r
      data['feed'] = Feed.with_unread_count.find(data['id'].to_i) if data['id']
      data['category'] = Category.find(data['category_id'].to_i) if data['category_id']
      payload[w] = data
      EventPool.remove w
    end
  end
end
