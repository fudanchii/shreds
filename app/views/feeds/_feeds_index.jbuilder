json.feeds feeds do |v|
  json.cid        v.category_id
  json.id         v.feed.id
  json.title      v.feed.title
  json.path       url_for(v.feed)
  json.url        v.feed.url
  json.has        ['newsitems']
  json.newsitems  v.entries[0, 3].each do |entry|
    json.partial! entry.newsitem, entry: entry, feed: v.feed
  end
end
json.prevPage link_to_previous_page feeds, 'Prev', params: { format: nil }
json.nextPage link_to_next_page feeds, 'Next', params: { format: nil }
