json.feeds feeds do |v|
  json.id       v.feed.id
  json.title    v.feed.title
  json.path     url_for v.feed
  json.url      v.feed.url
  json.has      ['newsitems']
  json.newsitems  v.entries[0, 3].each do |entry|
    json.id         entry.newsitem.id
    json.title      entry.newsitem.title
    json.path       url_for [v.feed, entry.newsitem]
    json.url        entry.newsitem.permalink
    json.author     entry.newsitem.author
    json.published  entry.newsitem.published.iso8601
    json.summary    entry.newsitem.summary
  end
end
json.prevPage   link_to_previous_page feeds, '< Prev', params: { format: nil }
json.nextPage   link_to_next_page feeds, 'Next >', params: { format: nil }
