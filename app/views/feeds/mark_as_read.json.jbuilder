
json.info '<strong>Feed</strong> marked as read.'

json.feed do
  json.id          @subscription.feed_id
  json.cid         @subscription.category.id
  json.unreadCount @subscription.unread_count
end
