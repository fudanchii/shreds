json.title       subscription.feed.title
json.favicon     subscription.feed.favicon
json.path        list_feed ? url_for(subscription.feed) : url_for(subscription)
json.cid         category_id
json.unreadCount unreads
json.active(' active') if @feed.respond_to?(:id) && @feed.id == subscription.feed.id

if newsitem.present?
  json.latestEntryTitle newsitem.title
  json.latestEntryPubDate newsitem.published.iso8601
end
