class EventsWatchContext < BaseContext
  class_attribute :payload, :watch_list

  at_execution :fetch_events

  def initialize(watch_str)
    self.watch_list = watch_str.split(',')
    self.payload = {}
  end

  private

  def fetch_events
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
