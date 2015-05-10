if @entry.unread
  json.info '<strong>Item marked</strong> as unread.'
else
  json.info '<strong>Item marked</strong> as read.'
end
json.feed do
  json.id @feed.id
  json.categoryId @subscription.category_id
  json.newsItemId @entry.newsitem_id
  json.unreadCount @subscription.unread_count
end
