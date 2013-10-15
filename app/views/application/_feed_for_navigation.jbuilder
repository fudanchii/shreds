json.id feed.id
json.title feed.title
json.favicon feed.favicon
json.path url_for(feed)
json.titleEllipsized truncate_moji(feed.title, length: 22, unescape: true)
json.unreadCount feed.unread_count
