json.id feed.id
json.title feed.title
json.favicon feed.favicon
json.path url_for(feed)
json.pathJson url_for({
  :controller => 'feeds',
  :action     => 'show',
  :id         => feed.to_param,
  :format     => :json
})
json.unreadCount feed.unread_count
