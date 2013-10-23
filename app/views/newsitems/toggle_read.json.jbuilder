if (@newsitem.unread) then
  json.info '<strong>Item marked</strong> as unread.'
else
  json.info '<strong>Item marked</strong> as read.'
end
json.feed do
  json.id @feed.id
  json.unreadCount @feed.unread_count
end
