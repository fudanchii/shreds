json.id         newsitem.id
json.title      newsitem.title
json.content    newsitem.content || newsitem.summary
json.summary    newsitem.summary
json.author     newsitem.author
json.url        newsitem.permalink
json.path       url_for [@feed, newsitem]
json.published_iso8601 newsitem.published.iso8601
json.published_str strdate(newsitem.published)
json.unread     newsitem.unread
json.readIcon   newsitem.unread ? 'ok-circle' : 'ok-sign'
json.read       newsitem.unread ? 'read' : 'unread'
