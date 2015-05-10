json.categories do
  @subscriptions.each do |category_id, category|
    json.set! category_id do
      json.name category[:name]
      json.has ['feeds']
      json.feeds do
        category[:feeds].each do |entry|
          json.set! entry[:feed].id do
            json.partial! 'feed_for_navigation',
                          feed: entry[:feed],
                          unreads: entry[:unreads],
                          newsitem: entry[:latest],
                          category_id: category_id
          end
        end
      end
    end
  end
end

if @subscription && @subscription.respond_to?(:category_id)
  json.selected do
    json.cid @subscription.category_id
    json.fid @feed.id if @feed.respond_to?(:id)
  end
end
