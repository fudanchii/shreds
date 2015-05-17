if @entry.unread
  json.info '<strong>Item marked</strong> as unread.'
else
  json.info '<strong>Item marked</strong> as read.'
end
json.feed do
  json.id          @feed.id
  json.cid         @subscription.category_id
  json.nid         @entry.newsitem_id
  json.unreadCount @subscription.unread_count
end
