
json.info '<strong>Feed</strong> marked as read.'

json.feed do
  json.id @subscription.feed.id
  json.unreadCount @subscription.unreads
end

