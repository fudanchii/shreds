class EventsWatch
  attr_reader :payload

  def initialize(watch_str)
    @payload = {}
    @watch_list = update_feed?(watch_str.split(','))
  end

  def update_feed?(list)
    f_idx = list.find_index { |w| w == 'updateFeed' }
    return list if f_idx.nil?
    list.delete_at f_idx
    @payload['updateFeed'] = { 'view' => 'feed_update' }
    list
  end

  def execute
    return if @watch_list.empty?
    result = EventPool.find(*@watch_list)
    @watch_list.zip(result).each do |w, r|
      next if r.nil?
      data = JSON.parse r
      data['feed'] = Feed.with_unread_count.find(data['id'].to_i) if data['id']
      if data['category_id']
        data['category'] = Category.find(data['category_id'].to_i)
      end
      @payload[w] = data
      EventPool.remove w
    end
  end
end
