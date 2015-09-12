json.cid        @subscription.category_id
json.id         @feed.id
json.url        @feed.url
json.title      @feed.title
json.newsitems  @entries do |entry|
  json.partial! entry.newsitem, entry: entry, feed: @feed
end
json.partial! 'feed_pager', entries: @entries
