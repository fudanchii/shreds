json.extract! @feed, \
    :url,
    :title,
    :etag,
    :favicon

json.newsitems @feed.newsitems do |json, newsitem|
  json.partial! newsitem
end
