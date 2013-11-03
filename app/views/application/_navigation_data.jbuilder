json.categories @categories do |category|
  json.id category.id
  json.name category.name.titleize
  json.has ['feeds']
  json.feeds category.feeds do |feed|
    json.partial! 'feed_for_navigation', feed: feed
  end
end
