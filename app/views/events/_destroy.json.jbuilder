json.info 'Successfully unsubscribed the feed.'

json.category do
  json.id data['category'].id
  json.feeds data['category'].feeds do |feed|
    json.partial! 'feed_for_navigation', feed: feed
  end
end
