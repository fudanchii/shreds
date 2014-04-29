json.categories @subscriptions.each do |category, feeds|
  json.name category.titleize
  json.has ['feeds']
  json.feeds feeds.each do |e|
    json.partial! 'feed_for_navigation', feed: e[0], unreads: e[1]
  end
end
