json.id         @entry.newsitem.id
json.feed_id    @entry.newsitem.feed_id
json.title      @entry.newsitem.title
json.url        @entry.newsitem.permalink
json.author     @entry.newsitem.author
json.published  @entry.newsitem.published.iso8601
json.content    @entry.newsitem.content || @entry.newsitem.summary
json.unread     @entry.unread
json.prevPath   url_for [@feed, @entry.newsitem.prev]
json.nextPath   url_for [@feed, @entry.newsitem.next]
json.noPrev     disabled? @entry.newsitem.prev
json.noNext     disabled? @entry.newsitem.next
