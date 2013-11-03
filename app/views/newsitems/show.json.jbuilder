json.id         @newsitem.id
json.feed_id    @newsitem.feed_id
json.title      @newsitem.title
json.url        @newsitem.permalink
json.readIcon   @newsitem.unread ? 'ok-circle' : 'ok-sign'
json.read       @newsitem.unread ? 'read' : 'unread'
json.author     @newsitem.author
json.published_iso8601 @newsitem.published.iso8601
json.published_str strdate(@newsitem.published)
json.content    @newsitem.content
json.prevPath   url_for [@feed, @newsitem.prev]
json.nextPath   url_for [@feed, @newsitem.next]
json.noPrev     disabled? @newsitem.prev
json.noNext     disabled? @newsitem.next
