json.extract! @feed,
    :url,
    :title,
    :etag,
    :favicon

json.newsitems @feed.newsitems do |newsitem|
  json.partial! newsitem
end
