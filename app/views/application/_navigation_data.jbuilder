json.categories @subscriptions.each do |category_name, category|
  json.id category[:id]
  json.name category_name.titleize
  json.has ['feeds']
  json.feeds category[:feeds].each do |entry|
    json.partial! 'feed_for_navigation',
        feed: entry[:feed],
        unreads: entry[:unreads],
        newsitem: entry[:latest],
        category_id: category[:id]
  end
end
