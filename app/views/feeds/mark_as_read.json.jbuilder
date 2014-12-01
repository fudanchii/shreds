
json.info '<strong>Feed</strong> marked as read.'

json.feed do
  json.id params[:id]
  json.categoryId @subscription.category.id
  json.unreadCount @subscription.unread_count
end
