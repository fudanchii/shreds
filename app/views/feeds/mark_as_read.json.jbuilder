
json.info '<strong>Feed</strong> marked as read.'

json.feed do
  json.id @subscription.feed.id
  json.categoryId @subscription.category.name
  json.unreadCount @subscription.unread_count
end
