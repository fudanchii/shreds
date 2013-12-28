json.id         @newsitem.id
json.feed_id    @newsitem.feed_id
json.title      @newsitem.title
json.url        @newsitem.permalink
json.author     @newsitem.author
json.published  @newsitem.published.iso8601
json.content    @newsitem.content || @newsitem.summary
json.unread     @newsitem.unread
json.prevPath   url_for [@feed, @newsitem.prev]
json.nextPath   url_for [@feed, @newsitem.next]
json.noPrev     disabled? @newsitem.prev
json.noNext     disabled? @newsitem.next
