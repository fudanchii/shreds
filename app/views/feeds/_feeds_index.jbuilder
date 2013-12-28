json.feeds feeds do |feed|
  json.id       feed.id
  json.title    feed.title
  json.path     url_for feed
  json.url      feed.url
  json.has      ['newsitems']
  json.newsitems feed.unread_newsitems.for_view.limit(3) do |newsitem|
    json.id         newsitem.id
    json.title      newsitem.title
    json.path       url_for [feed, newsitem]
    json.url        newsitem.permalink
    json.author     newsitem.author
    json.published  newsitem.published.iso8601
    json.summary    newsitem.summary
  end
end
json.prevPage   link_to_previous_page feeds, '< Prev', :params => { :format => nil }
json.nextPage   link_to_next_page feeds, 'Next >', :params => { :format => nil }
