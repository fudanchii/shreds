
json.info 'Feed marked as read.'

json.feed do
  json.id data['feed'].id
  json.unreadCount data['feed'].unread_count
end

