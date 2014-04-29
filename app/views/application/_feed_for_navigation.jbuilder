json.id feed.id
json.title feed.title
json.favicon feed.favicon
json.path url_for(feed)
json.unreadCount unreads
json.active(' active') if (@feed.respond_to?(:id) && @feed.id == feed.id)

newsitem = feed.newsitems.for_view.limit(1).first
json.latestEntryTitle newsitem.title
json.latestEntryPubDate newsitem.published.iso8601
