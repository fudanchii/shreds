if (@entry.unread)
  json.info '<strong>Item marked</strong> as unread.'
else
  json.info '<strong>Item marked</strong> as read.'
end
json.feed do
  json.id @entry.subscription.feed.id
  json.unreadCount @entry.subscription.feed.unread_count
end
