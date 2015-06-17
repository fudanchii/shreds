json.id        @entry.newsitem.id
json.cid       @subscription.category_id
json.fid       @entry.newsitem.feed_id
json.title     @entry.newsitem.title
json.url       @entry.newsitem.permalink
json.author    @entry.newsitem.author
json.published @entry.newsitem.published.iso8601
json.content   @entry.newsitem.content.presence || @entry.newsitem.summary
json.unread    @entry.unread
json.prevPath  url_for([@feed, @entry.newsitem.prev])
json.nextPath  url_for([@feed, @entry.newsitem.next])
json.noPrev    disabled?(@entry.newsitem.prev)
json.noNext    disabled?(@entry.newsitem.next)
