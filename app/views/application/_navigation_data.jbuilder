json.categories @subscriptions.each do |category, feeds|
  json.name category.titleize
  json.has ['feeds']
  json.feeds feeds.each do |entry|
    json.partial! 'feed_for_navigation', feed: entry[:feed], unreads: entry[:unreads], newsitem: entry[:latest]
  end
end
